# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------
export EDITOR=vim
export GPG_TTY=$(tty)
export KEYTIMEOUT=1
export USER_GIT_ROOT=${HOME}/git
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#53b0e3,bg=grey,bold,underline"
export MCFLY_RESULTS=25

# Add local bin directories to PATH
export PATH=${HOME}/.local/bin:${HOME}/bin:${PATH}

# ------------------------------------------------------------------------------
# Oh My Zsh Configuration
# ------------------------------------------------------------------------------
ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="kphoen"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"

# Add custom completions to fpath before sourcing Oh My Zsh
fpath=( ${HOME}/git/zsh/zsh-plugins/zsh-completions/src ${HOME}/git/zsh/zsh-plugins/cleos-zsh-completion $fpath )

# Zsh completion style
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true

# ------------------------------------------------------------------------------
# Plugins
# ------------------------------------------------------------------------------
# For OMZ to manage these, clone them into your custom plugins directory:
# git clone https://github.com/zsh-users/zsh-autosuggestions ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-autosuggestions
# git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ${ZSH_CUSTOM:-~/.oh-my-zsh/custom}/plugins/zsh-syntax-highlighting
plugins=(kubectl kubectx history web-search themes systemadmin aws docker docker-compose helm minikube tmux aliases alias-finder debian archlinux sprunge git sudo dirhistory systemd compleat lol zsh-autosuggestions zsh-syntax-highlighting)

# ------------------------------------------------------------------------------
# Source Oh My Zsh
# ------------------------------------------------------------------------------
source ${ZSH}/oh-my-zsh.sh

# ------------------------------------------------------------------------------
# Prompt
# ------------------------------------------------------------------------------
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

# ------------------------------------------------------------------------------
# Aliases
# ------------------------------------------------------------------------------
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

# ------------------------------------------------------------------------------
# Functions
# ------------------------------------------------------------------------------
envset() {
    if [ -d ${HOME}/git/zsh ]; then
        local pwd=$(pwd)
        cd ${HOME}/git/zsh
        git pull origin
        git submodule update --recursive --init
        cd "${pwd}"
    fi

    read "REPLY?This will overwrite existing dotfiles in your home directory. Are you sure? (y/n) "
    if [[ ! "$REPLY" =~ ^[Yy]$ ]]; then
        echo "Aborting."
        return 1
    fi

    echo "Setting up symlinks..."
    # Use -n to avoid following symlinks and -f to force overwrite
    ln -snf ${HOME}/git/zsh/oh-my-zsh ${HOME}/.oh-my-zsh
    ln -snf ${HOME}/git/zsh/vim ${HOME}/.vim
    find ${HOME}/git/zsh/dotfiles -maxdepth 1 -name ".*" -not -path ${HOME}/git/zsh/dotfiles/.git -exec ln -snf {} ${HOME} \;
    rm -f ${HOME}/.zcompdump
    echo "Done. Restarting Zsh..."
    exec zsh
}

t() {
    local SESSIONNAME="main"
    # Check if not already inside a tmux session
    if [ -z "$TMUX" ]; then
        tmux has-session -t "$SESSIONNAME" &> /dev/null
        [ $? != 0 ] && tmux new-session -s "$SESSIONNAME" -d
        tmux attach -t "$SESSIONNAME"
    else
        echo "Already in a tmux session."
    fi
}

# ------------------------------------------------------------------------------
# Initializations
# ------------------------------------------------------------------------------
[ -f ${HOME}/.localrc ] && source ${HOME}/.localrc
eval "$(mcfly init zsh)"
eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
[[ -e "/home/marques/lib/oracle-cli/lib/python3.12/site-packages/oci_cli/bin/oci_autocomplete.sh" ]] && source "/home/marques/lib/oracle-cli/lib/python3.12/site-packages/oci_cli/bin/oci_autocomplete.sh"