# dotfiles

Fully automated MAC development setup using ansible and homebrew

## Installation

This playbook includes a custom shell script located at `bin/dotfiles`. This script is added to your $PATH after installation and can be run multiple times while making sure any Ansible dependencies are installed and updated.

```bash
/bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/aurimas-zarskis/dotfiles/main/bin/dotfiles)"
```

## Update

To update your environment run the `dotfiles` command in your shell:

```bash
dotfiles
```

This `dotfiles` command is available to you after the first use of this repo, as it adds this repo's `bin` directory to your path, allowing you to call `dotfiles` from anywhere.

