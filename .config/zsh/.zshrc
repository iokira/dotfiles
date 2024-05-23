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

# alias
alias l='exa -la --icons'
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
alias gb='git branch'
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
