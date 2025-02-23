#!/bin/bash

# const
readonly DOTFILES_PATH=$HOME/dotfiles
readonly CSV_FILE=$DOTFILES_PATH/link.csv

# color settings
if which tput >/dev/null 2>&1; then
    ncolors=$(tput colors)
fi
if [ -t 1 ] && [ -n "$ncolors" ] && [ "$ncolors" -ge 8 ]; then
    BLUE="$(tput setaf 6)"
    BOLD="$(tput bold)"
    NORMAL="$(tput sgr0)"
else
    BLUE=""
    BOLD=""
    NORMAL=""
fi

# arrowhead message
arrow() {
    echo "${BLUE}==>${NORMAL} ${BOLD}${1}${NORMAL}"
}

unlink_config() {
    arrow "Unlinking ${1}"
    unlink "$HOME"/"$1"
}

unlink_from_csv() {
    arrow "Unlinking from csv file"
    while IFS=, read -r _ col2; do
        unlink_config "$col2"
    done <"$1"
}
main() {
    unlink_from_csv "$CSV_FILE"
}

main

exit 0
