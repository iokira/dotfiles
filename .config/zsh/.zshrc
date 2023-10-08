# Caution! This config should be written at the beginning of the file :) by io
# profiler
if [ "$ZSHRC_PROFILE" != "" ]; then
  zmodload zsh/zprof && zprof > /dev/null
fi

# comp
autoload -Uz compinit
compinit

zstyle ':completion:*' menu true
zstyle ':completion:*:rm:*' menu false
zstyle ':completion:*:(cd):*' matcher 'm:{a-z}={A-Z}'
zstyle ':completion:*:default' list-colors ''
zstyle ':completion:*' completer _complete _approximate
zstyle ':completion:*:default' menu select=1
zstyle ':completion::complete:*' use-cache true
setopt correct
SPROMPT="correct: $RED%R$DEFAULT -> $GREEN%r$DEFAULT ? [Yes/No/Abort/Edit] => "

# dir stack
setopt AUTO_PUSHD
setopt PUSHD_IGNORE_DUPS
setopt PUSHD_SILENT

alias di='dirs -v'
for index ({1..9}) alias "$index"="cd +${index}"; unset index

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
alias vim='nvim'
alias v='nvim'
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

# starship
eval "$(starship init zsh)"

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

function zsh-profiler() {
ZSHRC_PROFILE=1 zsh -i -c zprof
}

# plugins
source $HOME/.config/zsh/plugins/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
