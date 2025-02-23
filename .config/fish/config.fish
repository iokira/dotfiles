# Welcome to fish

function hi
    echo "Hi! I'm fish shell :)"
end

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
alias relogin "exec fish -l"

# GPG

export GPG_TTY=$(tty)

# PATH

## Homebrew
fish_add_path /opt/homebrew/bin

## Go
fish_add_path $HOME/go/bin

## rancher desktop
fish_add_path $HOME/.rd/bin

## Cargo
fish_add_path $HOME/.cargo/bin

## volta
set -gx VOLTA_HOME "$HOME/.volta"
set -gx PATH "$VOLTA_HOME/bin" $PATH

# starship
starship init fish | source

# fzf

fzf --fish | source
set -gx FZF_CTRL_T_OPTS "--preview 'bat --color=always --style=numbers --line-range=:500 {}'"
bind \cp fzf-history-widget
bind -M insert \cp fzf-history-widget
bind \cg fzf-cd-widget
bind -M insert \cg fzf-cd-widget

function fl
    git log --graph --color=always \
    --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" $argv |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
    --bind "ctrl-m:execute:
    (grep -o '[a-f0-9]\{7\}' | head -1 |
    xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
    {}
    FZF-EOF" --preview 'f() {
    set -- $(echo "$@" | grep -o "[a-f0-9]\{7\}" | head -1);
    if [ $1 ]; then
    git show --color $1
    else
    echo ""
    fi
    }; f {}' | grep -o "[a-f0-9]\{7\}" | tr '\n' ' '
end
