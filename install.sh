#!/bin/bash

# === const ===
# -------------

readonly DOTFILES_PATH=$HOME/dotfiles
readonly REMOTE_URL="https://github.com/iokira/dotfiles.git"
readonly BREW_PATH_MAC=/opt/homebrew/bin
readonly BREW_PATH_UBUNTU=/home/linuxbrew/.linuxbrew/Homebrew/bin

# === colors ===
# --------------

if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    RED="$(tput setaf 1)"
    GREEN="$(tput setaf 2)"
    YELLOW="$(tput setaf 3)"
    BLUE="$(tput setaf 6)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
else
    RED=""
    GREEN=""
    YELLOW=""
    BLUE=""
    BOLD=""
    NORMAL=""
fi

# === functions ===
# -----------------

detect_os() {
    UNAME=$(uname)

    if [ $UNAME == 'Darwin' ]; then
        OS='macOS'
    elif [ $UNAME == 'Linux' ]; then
        OS='Linux'
    else
        echo 'Who are you?'
        exit 1
    fi
}

has() {
    type "$1" > /dev/null 2>&1
}

install() {
    if has "$1"; then
        echo "${BOLD}${1} is already exists.$NORMAL"
    else
        echo "Installing ${1}..."
        $2
        if [ $? = 0 ]; then
            echo "${GREEN}Successfully installed ${1}.$NORMAL"
        else
            echo "${RED}An unexpected error occurred when trying to install ${1}.$NORMAL"
            exit 1
        fi
    fi

    return 0
}

successfully_link_message() {
    echo "${GREEN}Successfully link ${1} settings.$NORMAL"
}

arrow_message() {
    echo "${BLUE}==>${NORMAL} ${BOLD}${1}$NORMAL"
}

download_dotfiles() {
    arrow_message "Downloading dotfiles..."
    cd $HOME
    if [ ! -d $DOTFILES_PATH ]; then
        echo "Downloading dotfiles..."
        if has git; then
            git clone --recursive $REMOTE_URL $DOTFILES_PATH
        else
            echo "${RED}Please install git first and then run.$NORMAL"
            exit 1
        fi
        if [ $? = 0 ]; then
            echo "${GREEN}Successfully downloaded dotfiles.$NORMAL"
        else
            echo "${RED}An unexpected error occurred when trying to download clone$NORMAL"
            exit 1
        fi
    else
        echo "${BOLD}dotfiles is already exists.$NORMAL"
    fi
}

# macOS
install_brew() {
    arrow_message "Installing Homebrew..."
    /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
}

# macOS
install_git_for_mac() {
    arrow_message "Installing git..."
    install "git" "$BREW_PATH_MAC/brew install git"
}

# Ubuntu
install_git_for_ubuntu() {
    arrow_message "Installing git..."
    install "git" "sudo apt install git -y"
}

# macOS, Ubuntu
link_gitconfig() {
    arrow_message "Linking .gitconfig..."
    ln -snfv $DOTFILES_PATH/.gitconfig $HOME/.gitconfig
    successfully_link_message "gitconfig"
}

# macOS
install_wezterm_for_mac() {
    arrow_message "Installing wezterm..."
    install "wezterm" "$BREW_PATH_MAC/brew install --cask wezterm"
    mkdir -p $HOME/.config/wezterm
    ln -snfv $DOTFILES_PATH/.config/wezterm/wezterm.lua $HOME/.config/wezterm/wezterm.lua
}

# Ubuntu
install_wezterm_for_ubuntu() {
    arrow_message "Installing wezterm..."
    curl -LO https://github.com/wez/wezterm/releases/download/20230712-072601-f4abf8fd/wezterm-20230712-072601-f4abf8fd.Ubuntu20.04.deb
    sudo apt install -y ./wezterm-20230712-072601-f4abf8fd.Ubuntu20.04.deb | true
    mkdir -p $HOME/.config/wezterm
    ln -snfv $DOTFILES_PATH/.config/wezterm/wezterm.lua $HOME/.config/wezterm/wezterm.lua
}

# macOS
install_tmux_for_mac() {
    arrow_message "Installing and linking tmux..."
    install "tmux" "$BREW_PATH_MAC/brew install tmux"
    mkdir -p $HOME/.config/tmux
    ln -snfv $DOTFILES_PATH/.config/tmux/tmux.conf $HOME/.config/tmux/tmux.conf
    successfully_link_message "tmux"
}

# Ubuntu
install_tmux_for_ubuntu() {
    arrow_message "Installing and linking tmux..."
    install "tmux" "sudo apt install tmux -y"
    mkdir -p $HOME/.config/tmux
    ln -snfv $DOTFILES_PATH/.config/tmux/tmux.conf $HOME/.config/tmux/tmux.conf
    successfully_link_message "tmux"
}

# Ubuntu
install_zsh_for_ubuntu() {
    arrow_message "Installing zsh..."
    install "zsh" "sudo apt install zsh -y"
}

# macOS, Ubuntu
link_zsh() {
    arrow_message "Linking .zshrc..."
    ln -snfv $DOTFILES_PATH/.config/zsh/.zshrc $HOME/.zshrc
    successfully_link_message "zsh"
}

install_zsh_plugins() {
    arrow_message "Installing zsh plugins..."
    mkdir -p $HOME/.config/zsh/plugins
    git clone https://github.com/zsh-users/zsh-syntax-highlighting.git $HOME/.config/zsh/plugins/zsh-syntax-highlighting
}

# macOS
install_nvim_for_mac() {
    arrow_message "Installing and linking NeoVim and syncing packer..."
    install "nvim" "$BREW_PATH_MAC/brew install neovim"
    mkdir -pv $HOME/.config/nvim
    ln -snfv $DOTFILES_PATH/.config/nvim/init.lua $HOME/.config/nvim/init.lua
    ln -snfv $DOTFILES_PATH/.config/nvim/lua $HOME/.config/nvim/lua
    ln -snfv $DOTFILES_PATH/.config/nvim/.luarc.json $HOME/.config/nvim/.luarc.json
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    successfully_link_message "nvim"
}

# Ubuntu
install_nvim_for_ubuntu() {
    arrow_message "Installing and linking NeoVim and syncing packer..."
    install "nvim" "sudo apt install neovim -y"
    mkdir -pv $HOME/.config/nvim
    ln -snfv $DOTFILES_PATH/.config/nvim/init.lua $HOME/.config/nvim/init.lua
    ln -snfv $DOTFILES_PATH/.config/nvim/lua $HOME/.config/nvim/lua
    ln -snfv $DOTFILES_PATH/.config/nvim/.luarc.json $HOME/.config/nvim/.luarc.json
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    successfully_link_message "nvim"
}

# macOS
install_exa_for_mac() {
    arrow_message "Installing exa..."
    install "exa" "$BREW_PATH_MAC/brew install exa"
}

# Ubuntu
install_exa_for_ubuntu() {
    arrow_message "Installing exa..."
    install "exa" "sudo apt install exa -y"
}

# macOS
install_bat_for_mac() {
    arrow_message "Installing bat..."
    install "bat" "$BREW_PATH_MAC/brew install bat"
}

# Ubuntu
install_bat_for_ubuntu() {
    arrow_message"Installing bat..."
    install "bat" "sudo apt install bat -y"
}

# macOS
install_httpie_for_mac() {
    arrow_message "Installing httpie..."
    install "httpie" "$BREW_PATH_MAC/brew install httpie"
}

# Ubuntu
install_httpie_for_ubuntu() {
    arrow_message "Installing httpie..."
    install "httpie" "sudo apt install httpie -y"
}

# macOS, Ubuntu
link_idea() {
    arrow_message "Linking .ideavimrc..."
    ln -snfv $DOTFILES_PATH/.config/idea/.ideavimrc $HOME/.ideavimrc
    successfully_link_message "ideavim"
}

install_starship() {
    arrow_message "Installing startship..."
    curl -sS https://starship.rs/install.sh | sh
    ln -snfv $DOTFILES_PATH/.config/starship/starship.toml $HOME/.config/starship.toml
}

# macOS
install_go_for_mac() {
    arrow_message "Installing go..."
    install "go" "$BREW_PATH_MAC/brew install go"
}

# Ubuntu
install_go_for_ubuntu() {
    arrow_message "Installing go..."
    install "go" "$BREW_PATH_UBUNTU/brew install go"
}

# macOS
install_vim_startuptime_for_mac() {
    arrow_message "Installing vim_startuptime..."
    install "vim_startuptime" "go install github.com/rhysd/vim-startuptime@latest"
}

# Ubuntu
install_vim_startuptime_for_ubuntu() {
    arrow_message "Installing vim_startuptime..."
    install "vim_startuptime" "go install github.com/rhysd/vim-startuptime@latest"
}

# macOS
install_jetbrains_mono_for_mac() {
    arrow_message "Installing JetBrainsMono ..."
    mkdir -p ~/Library/Fonts/JetBrainsMono
    curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.zip
    unzip JetBrainsMono.zip -d ~/Library/Fonts/JetBrainsMono
    rm -f JetBrainsMono.zip
}

install_jetbrains_mono_for_ubuntu() {
    arrow_message "Installing JetBrainsMono..."
    mkdir -p ~/.local/share/fonts/JetBrainsMono
    curl -fLO https://github.com/ryanoasis/nerd-fonts/releases/download/v3.0.2/JetBrainsMono.tar.xz
    tar Jxfv JetBrainsMono.tar.xz -C ~/.local/share/fonts/JetBrainsMono
    rm -f JetBrainsMono.tar.xz
}

# macOS
install_softwares_for_mac() {
    install_brew
    install_git_for_mac
    download_dotfiles
    link_gitconfig
    install_wezterm_for_mac
    install_tmux_for_mac
    link_zsh
    install_zsh_plugins
    install_nvim_for_mac
    install_exa_for_mac
    install_bat_for_mac
    install_httpie_for_mac
    link_idea
    install_starship
    install_go_for_mac
    install_vim_startuptime_for_mac
    install_jetbrains_mono_for_mac
}

install_softwares_for_ubuntu() {
    install_git_for_ubuntu
    install_brew
    download_dotfiles
    link_gitconfig
    install_wezterm_for_ubuntu
    install_tmux_for_ubuntu
    install_zsh_for_ubuntu
    link_zsh
    install_zsh_plugins
    install_nvim_for_ubuntu
    install_exa_for_ubuntu
    install_bat_for_ubuntu
    install_httpie_for_ubuntu
    link_idea
    install_starship
    install_go_for_ubuntu
    install_vim_startuptime_for_ubuntu
    install_jetbrains_mono_for_ubuntu
}

# === main ===
# ------------

main() {
    detect_os
    if [ $OS == 'macOS' ]; then
        sudo echo ''
        install_softwares_for_mac
    elif [ $OS == 'Linux' ]; then
        sudo apt update
        install_softwares_for_ubuntu
    fi
}

main

exit 0
