# dotfiles

The best I could think of dotfiles.

## Features

* Editor: Neovim;
* Prompt: starship;
* Shell: fish;
* Terminal: wezterm;

## Contents

* Homebrew installer
* git installer
* wezterm config and installer
* tmux config and installer
* zsh config
* fish config and installer
* neovim config and installer
* ripgrep installer
* eza installer
* starship config and installer
* bat installer
* httpie installer
* go installer
* vim-startuptime installer
* jetbrains mono installer
* fzf installer
* ideavim config

## Link config files

Support the creation of symbolic links to configuration files listed in the `link.csv` file.

Example of how to write

```csv
$DOTFILES_PATH,$CONFIG_FILE_PATH
```

## Supported OS

* macOS (Apple silicon only)

## Install (for me)

### Requirements

* curl

```sh
bash -c "$(curl -fsSL https://raw.githubusercontent.com/iokira/dotfiles/main/install.sh)"
```

## Inspiration

https://github.com/yutkat/dotfiles

https://github.com/craftzdog/dotfiles-public

https://github.com/ayamir/nvimdots

## License

MIT

Copyright (c) 2021 - 2025 iokira
License under the MIT license.

