# const
readonly DOTFILES_PATH=$HOME/dotfiles
readonly REMOTE_URL="https://github.com/iokira/dotfiles.git"

# color settings
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

# displaying help messages
helpmsg() {
    echo "Usage: $0 [--help | -h]" 0>&2
    echo ""
}

# arrowhead message
arrow() {
    echo "${BLUE}==>${NORMAL} ${BOLD}${1}${NORMAL}"
}

# success message
success() {
    echo "${GREEN}${1}${NORMAL}"
}

# error message
error() {
    echo "${RED}${1}${NORMAL}"
    exit 1
}

# bold message
bold() {
    echo "${BOLD}${1}${NORMAL}"
}

# check for the existence #1
has() {
    type "$1" > /dev/null 2>&1
}

# detect os type
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

# if $1 does not exist, run $2
install() {
    arrow "Installing ${1}"
    if has "$1"; then
        bold "${1} is already exists."
    else
        arrow "Installing ${1}"
        ${@:2}
        if [ $? = 0 ]; then
            success "Successfully installed ${1}."
        else
            error "An unexpected error occurred when trying to install ${1}."
        fi
    fi
}

# download dotfiles
download_dotfiles() {
    arrow "Downloading dotfiles"
    cd $HOME
    if [ ! -d $DOTFILES_PATH ]; then
        if has git; then
            git clone --recursive $REMOTE_URL $DOTFILES_PATH
        else
            error "Please install git first and then run."
            exit 1
        fi
        if [ $? = 0 ]; then
            success "Successfully downloaded dotfiles."
        else
            error "An unexpected error occurred when trying to git clone"
        fi
    else
        bold "dotfiles is already exists."
    fi
}

# install brew
install_brew() {
    install brew /bin/bash -c "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/HEAD/install.sh)" < /dev/null
    echo 'eval "$(/opt/homebrew/bin/brew shellenv)"' >> $HOME/.zprofile
    eval "$(/opt/homebrew/bin/brew shellenv)"
}

# install git
install_git() {
    install git brew install git
    ln -snfv $DOTFILES_PATH/.gitconfig $HOME/.gitconfig
}

# install wezterm
install_wezterm() {
    install wezterm brew install --cask wezterm
}

# link wezterm config
link_wezterm() {
    mkdir -p $HOME/.config/wezterm
    ln -snfv $DOTFILES_PATH/.config/wezterm/wezterm.lua $HOME/.config/wezterm/wezterm.lua
    ln -snfv $DOTFILES_PATH/.config/wezterm/lua $HOME/.config/wezterm/lua
}

# install tmux
install_tmux() {
    install tmux brew install tmux
}

# link tmux config
link_tmux() {
    mkdir -p $HOME/.config/tmux
    ln -snfv $DOTFILES_PATH/.config/tmux/tmux.conf $HOME/.config/tmux/tmux.conf
}

# link zsh config
link_zsh() {
    ln -snfv $DOTFILES_PATH/.config/zsh/.zshrc $HOME/.zshrc
}

# install neovim
install_neovim() {
    install nvim brew install neovim
    mkdir -p $HOME/.config/nvim
    ln -snfv $DOTFILES_PATH/.config/nvim/init.lua $HOME/.config/nvim/init.lua
    ln -snfv $DOTFILES_PATH/.config/nvim/lua $HOME/.config/nvim/lua
    ln -snfv $DOTFILES_PATH/.config/nvim/.luarc.json $HOME/.config/nvim/.luarc.json
    git clone --depth 1 https://github.com/wbthomason/packer.nvim ~/.local/share/nvim/site/pack/packer/start/packer.nvim
    tempfile=$(mktemp) \
        && curl -o $tempfile https://raw.githubusercontent.com/wez/wezterm/master/termwiz/data/wezterm.terminfo \
        && tic -x -o ~/.terminfo $tempfile \
        && rm $tempfile
}

# install ripgrep
install_ripgrep() {
    install rg brew install ripgrep
}

# install exa
install_eza() {
    install eza brew install eza
}

# install starship
install_starship() {
    install starship brew install starship
    ln -snfv $DOTFILES_PATH/.config/starship/starship.toml $HOME/.config/starship.toml
}

# install bat
install_bat() {
    install bat brew install bat
}

# install httpie
install_httpie() {
    install httpie brew install httpie
}

# install go
install_go() {
    install go brew install go
}

# first get sudo, then for macos, do the installation process
main() {
    sudo echo ''
    detect_os
    if [ $OS = 'macOS' ]; then
        download_dotfiles
        install_brew
        install_git
        install_wezterm
        link_wezterm
        install_tmux
        link_tmux
        link_zsh
        install_neovim
        install_ripgrep
        install_eza
        install_starship
        install_bat
        install_httpie
        install_go
        success "Install completed!"
    else
        error 'not supported os'
    fi
}

# argument handling
while [ $# -gt 0 ]; do
    case ${1} in
        --debug|-d)
            set -uex
            ;;
        --help|-h)
            helpmsg
            exit 1
            ;;
        *)
            ;;
    esac
    shift
done

main

exit 0
