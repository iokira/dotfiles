readonly DOTFILES_PATH=$HOME/dotfiles
readonly REMOTE_URL="https://github.com/iokira/dotfiles.git"

has() {
    type "$1" > /dev/null 2>&1
}

install() {
    cd $HOME
    if [ ! -d $DOTFILES_PATH ]; then
        if has git; then
            git clone --recursive $REMOTE_URL $DOTFILES_PATH
        else
            exit 1
        fi
    fi
}

main() {
    install
}

main

exit 0
