{pkgs}: let
  inherit (pkgs) lib;

  quartzSrc = pkgs.fetchFromGitHub {
    owner = "jackyzha0";
    repo = "quartz";
    rev = "d25a6eabf96751ffca56f8a8139272def7a65041";
    hash = "sha256-eYSMjvo4pduIYQwY9lPBj19yzPJmE0j2xh7x/IHBm94=";
  };

  obsidianSrc = lib.fileset.toSource {
    root = ./.;
    fileset =
      lib.fileset.difference
      ./.
      (lib.fileset.unions [
        ./.obsidian
        ./devShell.nix
        ./package.nix
        (lib.fileset.maybeMissing ./node_modules)
        (lib.fileset.maybeMissing ./package-lock.json)
        (lib.fileset.maybeMissing ./package.json)
        (lib.fileset.maybeMissing ./public)
      ]);
  };
in
  pkgs.buildNpmPackage {
    pname = "obsidian";
    version = "unstable-2026-05-18";

    src = quartzSrc;

    npmDepsHash = "sha256-7u+VlIx44B3/ivM9vLMIOn+e4TL4eS6B682vhS+Ikb4=";

    dontNpmBuild = true;

    installPhase = ''
      runHook preInstall

      rm -rf content
      mkdir -p content
      cp -R ${obsidianSrc}/. content/
      chmod -R u+w content
      rm -rf content/.quartz

      node <<'EOF'
      const fs = require("fs")
      const path = require("path")

      const root = "content"

      const walk = (dir) => {
        const entries = fs.readdirSync(dir, {withFileTypes: true})
        return entries.flatMap((entry) => {
          const target = path.join(dir, entry.name)
          return entry.isDirectory() ? walk(target) : [target]
        })
      }

      const clean = (value) => {
        const trimmed = value.trim()
        if (
          (trimmed.startsWith('"') && trimmed.endsWith('"')) ||
          (trimmed.startsWith("'") && trimmed.endsWith("'"))
        ) {
          return trimmed.slice(1, -1)
        }

        return trimmed
      }

      const firstAlias = (frontmatter) => {
        const lines = frontmatter.split(/\r?\n/)

        for (const line of lines) {
          const scalar = line.match(/^aliases:\s*(.+?)\s*$/)
          if (scalar && scalar[1] !== "[]") {
            return clean(scalar[1])
          }
        }

        const aliasIndex = lines.findIndex((line) => /^aliases:\s*$/.test(line))
        if (aliasIndex === -1) {
          return null
        }

        for (const line of lines.slice(aliasIndex + 1)) {
          if (/^\S/.test(line)) {
            break
          }

          const item = line.match(/^\s*-\s+(.+?)\s*$/)
          if (item) {
            return clean(item[1])
          }
        }

        return null
      }

      for (const file of walk(root)) {
        if (!file.endsWith(".md")) {
          continue
        }

        const text = fs.readFileSync(file, "utf8")
        if (!text.startsWith("---\n")) {
          continue
        }

        const end = text.indexOf("\n---", 4)
        if (end === -1) {
          continue
        }

        const frontmatter = text.slice(4, end)
        if (/^title:\s*/m.test(frontmatter)) {
          continue
        }

        const title = firstAlias(frontmatter)
        if (!title) {
          continue
        }

        fs.writeFileSync(
          file,
          `---\ntitle: ''${JSON.stringify(title)}\n''${text.slice(4)}`,
        )
      }
      EOF

      cp ${obsidianSrc}/.quartz/quartz.config.ts quartz.config.ts
      cp ${obsidianSrc}/.quartz/quartz.layout.ts quartz.layout.ts

      node quartz/bootstrap-cli.mjs build --directory content --output "$out"

      runHook postInstall
    '';

    meta = {
      description = "Static Quartz site for obsidian.momee.mt";
      homepage = "https://obsidian.momee.mt";
      license = lib.licenses.mit;
    };
  }
