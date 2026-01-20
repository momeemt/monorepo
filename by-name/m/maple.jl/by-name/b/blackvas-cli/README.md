# Blackvas CLI
Hello. This is the CLI for Blackvas.

## Install

```bash
nimble install blackvas_cli
```

## Commands

### create
Create a Blackvas project.

```bash
blackvas_cli create --appName <app-name>
blackvas_cli create -a <app-name>
```

### generate
Generate the components file.

This command is only available when the project uses Atomic Design.

```bash
blackvas_cli generate --fileType <file-type> --name <file-name>
blackvas_cli generate -f <file-type> -n <file-name>
```

#### file-type
- atoms
- molecules
- organisms
- templates

### serve
This is used to check the Blackvas project with localserver.

http://localhost:5000

```bash
blackvas_cli serve
```