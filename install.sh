readonly DOTFILES_PATH=$HOME/dotfiles
readonly REMOTE_URL="https://github.com/iokira/dotfiles.git"

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

arrow() {
    echo "${BLUE}==>${NORMAL} ${BOLD}${1}${NORMAL}"
}

success() {
    echo "${GREEN}${1}${NORMAL}"
}

error() {
    echo "${RED}${1}${NORMAL}"
    exit 1
}

bold() {
    echo "${BOLD}${1}${NORMAL}"
}

has() {
    type "$1" > /dev/null 2>&1
}

install() {
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

main() {
    download_dotfiles
}

main

exit 0
