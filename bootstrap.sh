#!/bin/sh

set -eu

REPOSITORY_URL=${DOTFILES_REPOSITORY_URL:-https://github.com/iokira/dotfiles.git}
REPOSITORY_DIR=${DOTFILES_DIR:-"$HOME/dotfiles"}
BRANCH=${DOTFILES_BRANCH:-main}

if [ -t 1 ] && [ "${TERM:-dumb}" != "dumb" ] && [ -z "${NO_COLOR+x}" ]; then
    BLUE=$(printf '\033[34m')
    GREEN=$(printf '\033[32m')
    RED=$(printf '\033[31m')
    BOLD=$(printf '\033[1m')
    RESET=$(printf '\033[0m')
else
    BLUE=
    GREEN=
    RED=
    BOLD=
    RESET=
fi

section() {
    printf '\n%s==>%s %s%s%s\n' "$BLUE" "$RESET" "$BOLD" "$1" "$RESET"
}

success() {
    printf '    %s✓%s %s\n' "$GREEN" "$RESET" "$1"
}

fail() {
    printf '    %s✗%s %s\n' "$RED" "$RESET" "$1" >&2
    exit 1
}

[ "$(uname -s)" = "Darwin" ] || fail "Only macOS is supported."
[ "$(uname -m)" = "arm64" ] || fail "Only Apple silicon is supported."
command -v git >/dev/null 2>&1 || fail "Git is required. Run xcode-select --install first."

if [ -d "$REPOSITORY_DIR/.git" ]; then
    section "Using existing repository"
    origin=$(git -C "$REPOSITORY_DIR" config --get remote.origin.url 2>/dev/null || true)
    case $origin in
    "$REPOSITORY_URL")
        ;;
    https://github.com/iokira/dotfiles | git@github.com:iokira/dotfiles.git)
        [ "$REPOSITORY_URL" = https://github.com/iokira/dotfiles.git ] || fail "$REPOSITORY_DIR is not the expected dotfiles repository."
        ;;
    *)
        fail "$REPOSITORY_DIR is not the expected dotfiles repository."
        ;;
    esac
    success "$REPOSITORY_DIR"
elif [ -e "$REPOSITORY_DIR" ]; then
    fail "$REPOSITORY_DIR exists but is not a Git repository."
else
    section "Cloning dotfiles"
    mkdir -p "$(dirname "$REPOSITORY_DIR")"
    if ! git clone --branch "$BRANCH" "$REPOSITORY_URL" "$REPOSITORY_DIR"; then
        fail "Could not clone the dotfiles repository."
    fi
    success "Cloned to $REPOSITORY_DIR"
fi

[ -x "$REPOSITORY_DIR/dotfiles" ] || fail "The dotfiles CLI is missing. Update or remove $REPOSITORY_DIR first."
exec "$REPOSITORY_DIR/dotfiles" install
