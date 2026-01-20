# ❄️ flake-templates

A collection of Nix flake templates for personal use.

## Templates

### Rust

- Rust toolchain (from [oxalica/rust-overlay](https://github.com/oxalica/rust-overlay))
- Treefmt
- pre-commit-hooks

```sh
nix flake init --template "github:momeemt/flake-templates#rust"
```

## Tools

### ft

You can install an alias command to use templates included by `momeemt/flake-templates`.

```sh
nix profile install "github:momeemt/flake-templates"
ft rust
```

## LICENSE

MIT or Apache-2.0
