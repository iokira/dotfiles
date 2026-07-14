# dotfiles

Minimal dotfiles for Apple silicon Macs. Homebrew installs the tools and GNU Stow manages the configuration links.

## Requirements

- macOS on Apple silicon
- Git (`xcode-select --install`)
- curl

## Install

```sh
/bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/iokira/dotfiles/main/bootstrap.sh)"
```

The bootstrap script clones this repository to `~/dotfiles`, installs the packages in `Brewfile`, and links the files under `stow/home` into `$HOME`.

Set `DOTFILES_DIR` to clone elsewhere:

```sh
DOTFILES_DIR="$HOME/projects/dotfiles" /bin/sh -c "$(curl -fsSL https://raw.githubusercontent.com/iokira/dotfiles/main/bootstrap.sh)"
```

## Commands

```sh
./dotfiles plan
./dotfiles install
./dotfiles uninstall
```

- `plan` checks new links and conflicts without writing files.
- `install` installs missing Homebrew dependencies, migrates links from the old installer, and synchronizes the managed links.
- `uninstall` removes only links managed by GNU Stow. It leaves Homebrew packages and this repository untouched.

Existing files are never overwritten automatically. Resolve any conflict reported by GNU Stow, then run the command again.

Set `NO_COLOR=1` to disable colored output.

## License

MIT

Copyright (c) 2021 - 2026 iokira
