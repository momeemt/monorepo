#show link: underline

= GSoC 2024 Proposal: nixpkgs pnpm tooling (Project: NixOS)
Name: Mutsuha Asada
#v(-8pt)
Email: #link("mailto:me@momee.mt")
#v(-8pt)
Country and Timezone: Japan, UTC+9
#v(-8pt)
School Name and Study: University of Tsukuba, College of Information Science
#v(-8pt)
GitHub: #link("https://github.com/momeemt")

== Project Abstruct
Nix doesn't support completely to build pnpm package, although it claims a faster package manager than npm and yarn and a lot of programmer choose it to develop projects with nodejs recently.
The proposal aims to provide `fetchPnpmDeps` derivation which is FOD fetcher for pnpm packages. Other contributor has already submitted a pull request about the problem, but it doesn't guarantee integrity of build.
The author of this pr calls `pnpm install --frozen-lockfile --ignore-script --force` and checks an output hash. It seems to forget matching pnpm version.
I suggest to implement an original FOD fetcher like a `fetchNpmDeps` to solve this problem.


== Project Plan

== Time Commitment

== Experience

=== OSS Contributions

=== Work Experience
