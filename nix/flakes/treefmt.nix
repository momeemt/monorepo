_: {
  perSystem = {
    pkgs,
    lib,
    ...
  }: {
    treefmt = {
      package = pkgs.treefmt;
      enableDefaultExcludes = true;
      flakeCheck = true;
      flakeFormatter = true;
      projectRootFile = "flake.nix";
      settings.formatter.dockerfmt.options = lib.mkForce [
        "-w"
        "-n"
        "-i"
        "4"
      ];

      programs = {
        # GitHub Actions
        actionlint = {
          enable = true;
          package = pkgs.actionlint;
        };
        # FIXME: considering countermeasures for rate limiting on GitHub API
        # pinact = {
        #   enable = true;
        #   package = pkgs.pinact;
        #   priority = 0;
        #   update = true;
        #   verify = true;
        # };
        zizmor = {
          enable = true;
          package = pkgs.zizmor;
        };

        # Nix
        alejandra = {
          enable = true;
          package = pkgs.alejandra;
        };
        deadnix = {
          enable = true;
          package = pkgs.deadnix;
          no-lambda-arg = false;
          no-lambda-pattern-names = false;
          no-underscore = false;
        };
        statix = {
          enable = true;
          package = pkgs.statix;
        };

        # Markdown
        mdformat = {
          enable = true;
          package = pkgs.mdformat;
          plugins = ps:
            with ps; [
              mdformat-footnote
              mdformat-gfm
              mdformat-gfm-alerts
            ];
          excludes = [
            "packages/o/obsidian/**"
          ];
          settings = {
            end-of-line = "lf";
            number = true;
            wrap = 80;
          };
        };

        # Python
        ruff-check = {
          enable = true;
          package = pkgs.ruff;
        };
        ruff-format = {
          enable = true;
          package = pkgs.ruff;
          lineLength = 88;
        };

        # sh/bash
        shellcheck = {
          enable = true;
          package = pkgs.shellcheck;
        };
        shfmt = {
          enable = true;
          package = pkgs.shfmt;
          indent_size = 2;
          simplify = false;
        };

        # Lua
        stylua = {
          enable = true;
          package = pkgs.stylua;
          settings = {
            call_parentheses = "Always";
            collapse_simple_statement = "Never";
            column_width = 120;
            indent_type = "Spaces";
            indent_width = 2;
            line_endings = "Unix";
            quote_style = "AutoPreferDouble";
            sort_requires.enabled = true;
          };
        };

        # Terraform
        terraform = {
          enable = true;
          package = pkgs.terraform;
        };

        # YAML
        yamlfmt = {
          enable = true;
          package = pkgs.yamlfmt;
          settings = {
            line_ending = "lf";
            doublestar = true;
            continue_on_error = false;
            exclude = [
              "secrets/**"
            ];
            gitignore_excludes = true;
            formatter = {
              type = "basic";
              indent = 2;
              include_document_start = true;
              line_ending = "lf";
              retain_line_breaks = false;
              retain_line_breaks_single = false;
              disallow_anchors = false;
              max_line_length = 120;
              scan_folded_as_literal = false;
              indentless_arrays = false;
              drop_merge_tag = true;
              pad_line_comments = 1;
              trim_trailing_whitespace = true;
              eof_newline = true;
              indent_root_array = false;
              disable_alias_key_correction = false;
              force_array_style = "block";
            };
          };
        };

        # Dockerfile
        dockerfmt = {
          enable = true;
          package = pkgs.dockerfmt;
        };

        # TOML
        taplo = {
          enable = true;
          package = pkgs.taplo;
          settings = {
            formatting = {
              align_entries = true;
              align_comments = true;
              array_trailing_comma = true;
              array_auto_expand = true;
              array_auto_collapse = true;
              compact_arrays = false;
              compact_inline_tables = false;
              inline_table_expand = true;
              compact_entries = false;
              column_width = 80;
              indent_tables = true;
              indent_entries = true;
              indent_string = "  ";
              trailing_newline = true;
              reorder_keys = true;
              reorder_arrays = true;
              reorder_inline_tables = true;
              allowed_blank_lines = 2;
              crlf = false;
            };
          };
        };

        # Text
        autocorrect = {
          enable = true;
          package = pkgs.autocorrect;
          threads = 0; # auto
          excludes = [
            "packages/o/obsidian/**"
          ];
          settings = {
            context = {
              codeblock = "error";
            };
            rules = {
              fullwidth = "off";
              halfwidth-punctuation = "error";
              halfwidth-word = "error";
              no-space-fullwidth = "error";
              space-backticks = "error";
              space-bracket = "error";
              space-dash = "error";
              space-dollar = "error";
              space-punctuation = "error";
              space-word = "error";
              spellcheck = "warning";
            };
            # spellcheck.words = [];
            # textRules = {};
          };
        };
        typos = {
          enable = true;
          package = pkgs.typos;
          binary = false;
          configFile = "typos.toml";
          hidden = true;
          isolated = true;
          locale = "en";
          noCheckFilenames = false;
          noCheckFiles = false;
          noIgnore = false;
          noIgnoreDot = false;
          noIgnoreGlobal = false;
          noIgnoreParent = false;
          noIgnoreVCS = false;
          noUnicode = false;
          sort = true;
          threads = 0; # auto
        };
      };
    };
  };
}
