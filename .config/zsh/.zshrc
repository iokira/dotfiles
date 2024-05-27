# Caution! This config should be written at the beginning of the file :) by iokira
# profiler
if [ "$ZSHRC_PROFILE" != "" ]; then
    zmodload zsh/zprof && zprof > /dev/null
fi

# comp
autoload -Uz compinit
compinit

# vi mode
bindkey -v
export KEYTIMEOUT=1
cursor_mode() {
    cursor_block='\e[2 q'
    cursor_beam='\e[6 q'

    function zle-keymap-select {
        if [[ ${KEYMAP} == vicmd ]] ||
            [[ $1 = 'block' ]]; then
            echo -ne $cursor_block
        elif [[ ${KEYMAP} == main ]] ||
                [[ ${KEYMAP} == viins ]] ||
                [[ ${KEYMAP} = '' ]] ||
                [[ $1 = 'beam' ]]; then
                echo -ne $cursor_beam
        fi
    }

    zle-line-init() {
        echo -ne $cursor_beam
    }

    zle -N zle-keymap-select
    zle -N zle-line-init
}
cursor_mode

# fzf functions
function fzf-select-history() {
    BUFFER=$(history -n -r 1 | fzf --query "$LBUFFER" --reverse)
    CURSOR=$#BUFFER
    zle reset-prompt
}
zle -N fzf-select-history
bindkey '^p' fzf-select-history

fd() {
    local dir
    dir=$(find ${1:-.} -path '*/\.git*' -prune -o -type d -print 2> /dev/null | fzf +m) && cd "$dir"
}

fb() {
    local branches branch
    branches=$(git branch -vv) &&
    branch=$(echo "$branches" | fzf +m) &&
    git checkout $(echo "$branch" | awk '{print $1}' | sed "s/.* //")
}

fl() {
    git log --graph --color=always \
        --format="%C(auto)%h%d %s %C(black)%C(bold)%cr" "$@" |
    fzf --ansi --no-sort --reverse --tiebreak=index --bind=ctrl-s:toggle-sort \
        --bind "ctrl-m:execute:
            (grep -o '[a-f0-9]\{7\}' | head -1 |
                xargs -I % sh -c 'git show --color=always % | less -R') << 'FZF-EOF'
                {}
FZF-EOF"
}

fv() {
    local file
    file=$(find ${1:-.} -path '*/\.git*' -prune -o -type f -print 2> /dev/null | fzf +m --preview "bat -f {}") && env TERM=wezterm nvim "$file"
}

# alias
alias l='eza -la --icons'
alias p='cd ~/projects'
alias d='cd ~/dotfiles'
alias ..='cd ..'
alias ...='cd ../..'
alias ....='cd ../../..'
alias rm='rm -iv'
alias cp='cp -iv'
alias nvim='env TERM=wezterm nvim'
alias v='env TERM=wezterm nvim'
alias g='git'
alias gs='git status'
alias ga='git add'
alias gc='git commit -m'
alias gac='git add --all && git commit -m'
alias gp='git push'
alias gl='git pull'
alias gd='git diff'
alias gco='git checkout'
alias gcob='git checkout -b'
alias gb='git branch -vv'
alias dp='docker ps'
alias dc='docker compose'
alias dcu='docker compose up'
alias dcd='docker compose down'
alias dcl='docker compose logs -f'
alias dce-'docker compose exec'
alias dcb='docker compose build'
alias nvim-startuptime='vim-startuptime -vimpath nvim'
alias shutnow='shutdown -h now'
alias relogin='exec zsh -l'

# startuptime
function zsh-startuptime() {
    local total_msec=0
    local msec
    local i
    for i in $(seq 1 10); do
        msec=$((TIMEFMT='%mE'; time zsh -i -c exit) 2>/dev/stdout > /dev/null)
        msec=$(echo $msec | tr -d "ms")
        echo "${(l:2:)i}: ${msec} [ms]"
        total_msec=$(( $total_msec + $msec ))
    done
    local average_msec
    average_msec=$(( ${total_msec} / 10 ))
    echo "\naverage: ${average_msec} [ms]"
}

# starship
eval "$(/opt/homebrew/bin/brew shellenv)"
eval "$(starship init zsh)"

# plugins
source $HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
