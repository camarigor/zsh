export PATH=${HOME}/bin:${PATH}
export PATH=${HOME}/.local/bin:${PATH}
export EDITOR=vim
export GPG_TTY=$(tty)
export KEYTIMEOUT=1
export USER_GIT_ROOT=${HOME}/git
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#53b0e3,bg=grey,bold,underline"
export MCFLY_RESULTS=25

HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
ZSH_THEME="kphoen"
ZSH="${HOME}/.oh-my-zsh"

plugins=(kubectl kubectx history web-search themes systemadmin aws docker docker-compose helm minikube tmux aliases alias-finder debian archlinux sprunge git sudo dirhistory systemd compleat lol)

source /usr/share/zsh-autosuggestions/zsh-autosuggestions.zsh
source /usr/share/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh
source ${ZSH}/oh-my-zsh.sh

ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg_bold[blue]%}"
PROMPT='[%{$fg[red]%}$(date +%T) %{$fg_bold[yellow]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}$(git_prompt_info)]
%# '
TPUT_END=$(tput cup 9999 0)
PS1="${TPUT_END}${PS1}"

function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{${fg_bold[yellow]}%} [% NORMAL]%  %{${reset_color}%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} ${EPS1}"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

unsetopt nomatch

fpath=( ${HOME}/git/zsh/zsh-plugins/zsh-completions/src ${HOME}/git/zsh/zsh-plugins/cleos-zsh-completion $fpath )
autoload -U colors && colors
autoload -U compinit promptinit
compinit
promptinit
# https://github.com/OWDIN/cleos-zsh-completion
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true

alias cdg="cd ${USER_GIT_ROOT}"
alias g="git"
alias ptpb="curl https://ptpb.pw -F c=@-"
alias sz="source ${HOME}/.zshrc"
alias vi="vim"
alias renner="cd /home/marques/documents/renner"
alias tfinit="terraform init --reconfigure --upgrade"
alias tfplan="terraform plan"
alias tfapply="terraform apply"
alias shut="sudo shutdown -h now"
alias reboot="sudo reboot now"
alias vpn="openvpn3 session-start --config vpn-agg"
alias vpnr="openvpn3 session-start --config vpn-repassa"
alias scripts="cd ${HOME}/Documents/personal/scripts"
[ -f ${HOME}/.localrc ] && source ${HOME}/.localrc

envset() {
    if [ -d ${HOME}/git/zsh ]; then
        pwd=$(pwd)
        cd ${HOME}/git/zsh
        git pull origin
        git submodule update --recursive --init
        cd ${pwd}
    fi
    rm -rf ${HOME}/.oh-my-zsh && ln -s ${HOME}/git/zsh/oh-my-zsh ${HOME}/.oh-my-zsh
    rm -rf ${HOME}/.vim && ln -s ${HOME}/git/zsh/vim ${HOME}/.vim
    find ${HOME}/git/zsh/dotfiles -maxdepth 1 -name ".*" -not -path ${HOME}/git/zsh/dotfiles/.git -exec ln -s {} ${HOME} \;
    rm -f ${HOME}/.zcompdump
    source ${HOME}/.zshrc
}

t() {
    SESSIONNAME="main"
    tmux has-session -t $SESSIONNAME &> /dev/null
    [ $? != 0 ] && tmux new-session -s $SESSIONNAME -d
    tmux attach -t $SESSIONNAME
}

eval "$(mcfly init zsh)"
eval $(thefuck --alias )
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
