# Welcome to fish

set fish_greeting

# vi mode
fish_hybrid_key_bindings

# Alias

alias l "eza -la --icons"
alias p "cd ~/projects"
alias d "cd ~/dotfiles"
alias .. "cd .."
alias ... "cd ../.."
alias .... "cd ../../.."
alias rm "rm -iv"
alias cp "cp -iv"
alias nvim "env TERM=wezterm nvim"
alias v "env TERM=wezterm nvim"
alias g "git"
alias nvim-startuptime "vim-startuptime -vimpath nvim"
alias shutnow "shutnow -h now"
alias relogin-zsh "exec zsh -l"
alias relogin-fish "exec fish -l"

# PATH

## Homebrew
set -gx PATH $PATH /opt/homebrew/bin

## Go
set -gx PATH $PATH $HOME/go/bin

## rancher desktop
set -gx PATH $PATH $HOME/.rd/bin

## Cargo
set -gx PATH $PATH $HOME/.cargo/bin

## volta
set -gx VOLTA_HOME $VOLTA_HOME $HOME/.volta
set -gx PATH $PATH $VOLTA_HOME/bin

# starship
starship init fish | source
