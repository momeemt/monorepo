#show link: underline
#show link: set text(fill: rgb(0, 0, 255))

= GSoC 2024 Proposal: nixpkgs pnpm tooling (Project: NixOS)
Name: Mutsuha Asada
#v(-4pt)
Email: #link("mailto:me@momee.mt")
#v(-4pt)
Country and Timezone: Japan, UTC+9
#v(-4pt)
School Name and Study: University of Tsukuba, College of Information Science
#v(-4pt)
GitHub: #link("https://github.com/momeemt")

== Abstruct
pnpm is #link("https://pnpm.io/#:~:text=pnpm%20is%20up%20to%202x%20faster%20than%20npm", "twice as fast"); compared to npm, and is a nodejs package manager that claims to be efficient in its use of disk space as dependent packages are replicated or hard A nodejs package manager that claims to be efficient in its use of disk space by being linked.

Nixpkgs provides `buildNpmPackage`, a derivation for building projects managed by npm, and `fetchNpmDeps` and `fetchYarnDeps`, derivations for fetching dependencies, but these are almost incompatible#footnote("The differences between npm and pnpm are explained in later chapters.") and,
They do not provide an official means of building pnpm.
I would therefore like to add a fetcher to prepare dependencies and a builder to package them in a nodejs project using pnpm.
This would have the following advantages.

=== Easier to add pnpm packages
Adding the new fetcher to nixpkgs will make it easier than before to contribute additional projects using pnpm!

Currently each package fetches pnpm packages individually, but if there is a bug, the more packages there are, the harder it is to fix.
It also makes it harder to contribute because developers have to understand pnpm's behaviour and understanding of the FOD.

The number of people downloading pnpm in 2022 has increased fivefold compared to 2021, as shown below, and pnpm has become increasingly important in recent years.

#figure(
  image("./pnpm-downloads.png"),
  caption: [
    referenced from #link("https://pnpm.io/blog/2022/12/30/yearly-update", "The year 2022 for pnpm");
  ]
)

In addition, pnpm is already used in many projects.
The front-end frameworks #link("https://github.com/vuejs/core", "vuejs/core"); and #link("https://github.com/sveltejs/svelte", "sveltejs/svelte "); employ pnpm.
It also uses tools such as #link("https://github.com/Vencord/Vesktop", "Vencord/vesktop"); included in Nixpkgs.
It is important that the pnpm tools are in place so that nixpkgs, a huge repository compared to other Linux distributions, can continue to support a wide range of software.

Furthermore, pnpm users will also benefit from being able to package with Nix.
While pnpm can manage dependent libraries with version and consistency hashes via lock files, Nix ensures reproducibility of all software involved in the build, not just the nodejs library.
For example, the image processing library sharp downloads platform-specific binaries during the build, which can cause different behaviour in local and CI environments.
Many developers using nodejs are plagued by such non-reproducible builds, so Nix's support for pnpm could contribute to an increase in Nix users.

=== Common build tools
Hopefully, it will allow for a common set of nodejs build tools.
Currently, `fetchNpmDeps`, `fetchYarnDeps` and many other tools outside Nixpkgs are implemented independently.

`fetchNpmDeps` appears to work well.
The JavaScript ecosystem changes at a relatively fast pace, so new tools other than pnpm may emerge, but by building `fetchPnpmDeps` with reference to `fetchNpmDeps`, a common process for handling nodejs package managers in Nix It may be possible to bundle a common process for handling nodejs package managers in Nix as a library.

== Efforts to date
First, let's organise the Nix community's work on the pnpm tool so far.

=== `pnpm2nix`
#link("https://github.com/nix-community/pnpm2nix", "pnpm2nix") is a tool to convert pnpm lockfiles into Nix expressions.
This approach is often adopted for programming languages with package managers that can output lock files.
This tool was updated 4 years ago, but is no longer updated.
#link("https://github.com/pnpm/pnpm/issues/1035", "pnpm/pnpm #1035"). pnpm has the problem that the integrity hash (`integrity`) is sometimes not listed in the lockfile, as described in and it is not possible to build individual packages.

=== `fetchPnpmDeps`
A possible workaround for the pnpm problem is to use fixed output derivation (hereafter FOD).
Nix forbids network connectivity in normal builds to ensure reproducibility, but this restriction can be very annoying if you need to install dependent software.
Therefore, it is possible to indicate in advance the hash value of the file to be obtained and then retrieve the file over the network to check whether the same file has been obtained. This is called FOD.
The recently submitted #link("https://github.com/NixOS/nixpkgs/pull/290715", "NixOS/nixpkgs #290715") is a fetcher of dependent packages using FOD.

This seems to solve the problem, but there is no guarantee that dependency resolution will be done in the same way if the pnpm version changes.
Although `pnpm install` is used to fetch packages, if the `pnpm` implementation or dependent libraries change, the build may not reproduce.

== Technical description
To solve these problems, we define our own FOD fetcher that parses pnpm lock files and creates a global store for pnpm.
Although `fetchNpmDeps` is provided, it is not compatible with npm and pnpm, so it is worth providing a new one for pnpm.

=== Differences between npm and pnpm
Specifically, there are the following differences between npm and pnpm

- Lock files.
  - npm generates a lock file in JSON format called `package-lock.json`, while pnpm generates a lock file in YAML format called `package-lock.yaml`.
- Directory structure
  - While npm keeps its dependent packages in a flat structure in `node_modules`, pnpm keeps them in a nested structure, duplicated or hard-linked from storage to save disk space.
  - Specifically, the official pnpm blog #link("https://pnpm.io/blog/2020/05/27/flat-node-modules-is-not-the-only-way", "Flat node_modules is not the only way").

=== Global store
Instead of using the `pnpm install` command, the newly implemented fetcher creates a global store in `$out` and runs the `pnpm config set store-dir $out` command.
The path to the pnpm global store is `~/Library/pnpm/store/v3` in my environment and can be looked up by the `pnpm store path` command.
There are many directories in `~/Library/pnpm/store/v3/files/` with the top two characters of the hash value (a two-digit hexadecimal integer).

Files contained in packages installed by pnpm will first have their hash values calculated.
https://github.com/pnpm/pnpm/blob/d4e13ca969ebab5da630c1351f8ed9a89a975108/store/cafs/src/getFilePathInCafs.ts#L25-L31

The file name is then determined by the hash value and stored in the global store.
https://github.com/pnpm/pnpm/blob/d4e13ca969ebab5da630c1351f8ed9a89a975108/store/cafs/src/getFilePathInCafs.ts#L17-L23

Also, packages that do not have an integrity hash in the lock file are handled in the same way, as `integrity.json` is created at the stage of storing them in the global store.

=== `fetchNpmDeps`
The `fetchNpmDeps` is used as a reference for the implementation of the fetcher. Particular attention is given to the following sections.

This function parses a lockfile and converts it into the dependent package (of type `Package`).
https://github.com/NixOS/nixpkgs/blob/2b3db9aeca054ae93126354e666394854edf5357/pkgs/build-support/node/fetch-npm-deps/src/parse/mod.rs#L18-L22

The `Package` has the package name, URL and integrity hash.
https://github.com/NixOS/nixpkgs/blob/918363e6fced7ae9e27c6b0c36195c2f9f94adde/pkgs/build-support/node/fetch-npm-deps/src/parse/lock.rs#L72-L78

For pnpm, the lock file is in YAML format, but we use the serde library for deserialisation. serde has a JSON target, serde_json, and a YAML target, serde_yaml, which can be used for pnpm without cost.

Also, in implementing pnpm's global store, the program to manipulate the cache that `fetchNpmDeps` has is very helpful.
https://github.com/NixOS/nixpkgs/blob/918363e6fced7ae9e27c6b0c36195c2f9f94adde/pkgs/build-support/node/fetch-npm-deps/src/cacache.rs#L54-L124

=== Comparison with `pnpm2nix`
`pnpm2nix` takes the approach of converting lockfiles to Nix expressions, which makes it easier to integrate with the Nix ecosystem compared to FOD fetchers.
Dependent package builds can be ported and extended to NixOS and other Nix-based systems.
However, `pnpm2nix` is fully dependent on lock files and requires that the integrity hashes of all packages are written.
Currently, pnpm has a problem with #link("https://github.com/pnpm/pnpm/issues/1035", "pnpm/pnpm #1035").
Overall, it is better to focus on the new FOD fetcher.

=== Comparison with `fetchPnpmDeps`
One problem with the currently submitted `fetchPnpmDeps` is that different versions of pnpm may change the dependency resolution method and build reproducibility cannot be fully guaranteed.
Compared to this fetcher, the new FOD fetcher creates a pnpm global store from a lock file, so dependencies are resolved in the same way even if different pnpm versions are used.
Furthermore, the new fetcher creates a new global store separately, so it does not mix with libraries on which other projects depend. Hardlinking, or duplicating, from the only store is clever in terms of saving disk space, but at the expense of build reproducibility.
Therefore, you will get very high build reproducibility and dependency resolution accuracy compared to `fetchPnpmDeps`.

== Goals

=== Primary

==== Implement a New FOD Fetcher for pnpm
As described, I will implement a new FOD fetcher for pnpm that ensures consistent dependency resolution even when pnpm versions change by analyzing the lock file and creating a global store.

==== Documentation for Source Code
Implementing an FOD fetcher to nixpkgs' standards within the GSoC period might be challenging. However, I plan to continue beyond the period, ensuring that other users can read and improve my code. Adequate references and comments will be necessary, especially regarding pnpm-specific knowledge.

==== Documentation Maintenance
Besides source code documentation, it's necessary to add documentation for users of the fetcher on the nodejs page.

=== Extra

==== Use the Implemented pnpm Fetcher for Existing pnpm Projects
As a test, we'll see if the right global store can be created from several lock files and if the builds are reproducible. Then, using the implemented fetcher on existing pnpm projects to check for any issues will partially prove the fetcher's practicality.

=== Hard

==== Solving pnpm/pnpm \#1035
Implementing a new FOD fetcher for pnpm requires a thorough understanding of pnpm's implementation. Tackling this issue could deepen understanding of pnpm, potentially leading to bug fixes or new feature implementations. Resolving pnpm/pnpm \#1035 to make pnpm2nix work would be beneficial for increasing reproducibility, beneficial both to pnpm users and the Nix community.

==== Announcements
If the new FOD fetcher is implemented and documentation and tests are prepared, we'll need to announce it to inform many users.

== Project Schedule (bi-weekly)

=== May 1 to May 20
Preparation period for the project. Read the source of pnpm to understand the implementation of the global store. Also, consider the design to enhance the reproducibility of builds.

=== May 21 to June 3
Start the project! Implement the analysis of pnpm's lock files and download package tarballs.

=== June 4 to June 17
Calculate the integrity hash of the downloaded packages and create a global store. The goal is to make it possible to build a standalone package with no dependencies.

=== June 18 to July 1
Continue to create the global store. The goal is to make it possible to build packages with complex dependencies.

=== July 2 to July 15
Create a builder for buildNpmPackage. The goal is to ensure that the build of a simple pnpm package works correctly.

=== July 16 to July 29
Continue to create the builder. The goal is to ensure that the build of pnpm packages with complex dependencies, which are actually incorporated into nixpkgs, works correctly.

=== July 30 to August 12
Create documentation for the new fetcher and builder. The goal is to make it possible for anyone to start using them, including examples of existing pnpm packages.

=== August 13 to August 26
I think it will be difficult to execute the above schedule perfectly. There might be some accidents or delays in the work. Therefore, this period is left as a buffer. If possible, I would like to work on resolving pnpm/pnpm \#1035 and making adjustments towards merging.

== Experience
=== OSS Contributions
I have been developing several pieces of software on GitHub, including those developed with multiple people and those receiving Pull Requests from users.

#link("https://github.com/momeemt")

I would like to contribute not only to Nixpkgs but also to Nix itself and related tools. I am using Nix for development on a regular basis, and I am currently in the process of replacing my home server with NixOS.

==== Brack Language (Aug. 2022 to present)
In the development of Brack, a markup language designed to simplify the creation of domain‒specific documents, I’ve taken a leadership role. Starting as a solo project, I spent over a year refining its design and implementation, focusing on a syntax that enables easy command invocation through Wasm binaries. Recently, the project has evolved into a collaborative effort, where I’ve been responsible for integrating advanced features like the Language Server Protocol, delegating tasks such as LSP implementation and documentation to my partner. This approach has significantly improved the functionality and usability of Brack, offering an efficient alternative to traditional document creation methods. (Rust, WebAssembly, Nix) #link("https://github.com/brack-lang/brack", "[repo]")

==== Sohosai (Mar. 2022 to Oct. 2023)
At our university festival, I led a 10‒person team to implement a new email system and develop a web platform, streamlining communications and information management for over 30,000 attendees. We successfully introduced personalized emails with enhanced security and a visitor‒friendly website with maps and event schedules, significantly improving festival operations. The projects, involving challenges like integrating advanced features cost‒effectively, were completed within tight deadlines. My role encompassed strategic planning, overseeing technical implementation, and adapting to unexpected changes, ensuring both initiatives enhanced visitor experience and operational efficiency. (Rust, Nix, Terraform, Docker, Roundcube, Sakura Cloud) #link("https://sohosai.com/", "[Website]") #link("https://github.com/sohosai/sos-backend", "[GitHub]");

==== mock up (Mar. 2021 to Dec. 2023)
Developed “mock up,” a versatile framework for video editing using JSON/YAML, utilizing Nim and GLSL for easy plugin development and ensuring high extensibility. This framework allows for the conversion of data to standard formats, facilitating the integration of video processing capabilities into existing systems. Dedicated two years to this project as a solo endeavor, focusing on the proactive design of plugins that can be easily implemented with minimal code and GLSL, streamlining the addition of advanced video editing features. (Nim, FFmpeg, OpenGL) #link("https://github.com/mock-up/mock-up", "[repo]")

==== Piledit (Mar. 2020 to Mar. 2021)
Together with a friend, I co‒developed “Piledit,” a block‒based video editing software inspired by observing a high school student’s difficulties with traditional editing tools. Aimed at offering an intuitive editing solution, Piledit has been notably accessible for students, providing an easier alternative to software like AviUtl. Over the course of a year, we divided our efforts: I focused on the frontend, designing block behaviors and data conversion, while also overseeing the project direction and distributing tasks, including backend development. (TypeScript, Electron, C\#, ASP.NET)
#link("https://github.com/Motionline/Piledit-FrontEnd")[[frontend]]
#link("https://github.com/Motionline/Piledit-BackEnd")[[backend]]
#link("https://sechack365.nict.go.jp/achievement/2020/pdf/2020_10.pdf")[[pdf(ja)]]

=== Work Experience

==== University of Tsukuba, College of Information Science (Dec. 2022 to May 2023)
In the university’s freshman welcome committee, we created a pamphlet and organized events to help new students acclimate. We used GitHub for a consistent and reproducible writing process. The pamphlet took two of us three months to produce, and organizing events required a three‒person team for four months. My contributions included coordinating with department contributors, managing schedules, and setting up the collaborative environment. (SATySFi, dune, Docker, GitHub Actions)

==== Security minicamp Tutor (Sep. 2022)
Assisted lectures as a tutor for the Security Camp, a training program conducted by the Ministry of Economy, Trade and Industry.

==== PIXIV Summer Internship (Aug. to Sep. 2022)
At PIXIV, I enhanced the ImageFlux image processing service by integrating FFmpeg and OpenH264, enabling it to compress and output mp4 files using the H.264 codec, in addition to its existing GIF animation conversion capability. This development responded to the growing demand for video content on the web and significantly increased the efficiency of video file conversions, achieving speeds up to 12 to 19 times faster than before. The upgrade greatly benefited users engaged in web‒based content distribution. I completed this project independently in just seven days, focusing on incorporating FFmpeg into the existing system, evaluating various technical options including existing wrapper libraries and cgo, to ensure the program’s quality. (Go, C, bash, FFmpeg, OpenH264) #link("https://www.slideshare.net/ssuser5997de/pixiv-summer-boot-camp-2022")[\[pdf(ja)\]]

==== Invast Inc. Internship (Jan. to Sep. 2022)
I participated in the development of an application related to securities education. I was in charge of examining and correcting bugs based on feedback from actual users. (TypeScript, Vue.js)
