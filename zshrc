# ------------------------------------------------------------------------------
# Performance Profiling (uncomment to profile startup time)
# ------------------------------------------------------------------------------
# zmodload zsh/zprof

# ------------------------------------------------------------------------------
# Environment Variables
# ------------------------------------------------------------------------------
export EDITOR=vim
export GPG_TTY=$(tty)
export KEYTIMEOUT=1
export USER_GIT_ROOT=${HOME}/git
export ZSH_AUTOSUGGEST_HIGHLIGHT_STYLE="fg=#53b0e3,bg=#808080,bold,underline"
export MCFLY_RESULTS=25
export BUN_INSTALL="$HOME/.bun"

# Add local bin directories to PATH
export PATH=${HOME}/.local/bin:${HOME}/bin:${HOME}/.opencode/bin:${BUN_INSTALL}/bin:${PATH}

# Security: Set default file creation mask
umask 022

# ------------------------------------------------------------------------------
# History Configuration
# ------------------------------------------------------------------------------
HISTSIZE=50000
SAVEHIST=50000
HISTFILE=~/.zsh_history

# ------------------------------------------------------------------------------
# Oh My Zsh Configuration
# ------------------------------------------------------------------------------
ZSH="${HOME}/.oh-my-zsh"
ZSH_THEME="kphoen"
HYPHEN_INSENSITIVE="true"
ENABLE_CORRECTION="true"
DISABLE_AUTO_UPDATE="false"
UPDATE_ZSH_DAYS=7
DISABLE_MAGIC_FUNCTIONS="true"
DISABLE_LS_COLORS="false"
DISABLE_AUTO_TITLE="false"
COMPLETION_WAITING_DOTS="true"
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Add custom completions to fpath before sourcing Oh My Zsh
fpath=( ${HOME}/git/zsh/zsh-plugins/zsh-completions/src ${HOME}/git/zsh/zsh-plugins/cleos-zsh-completion $fpath )

# ------------------------------------------------------------------------------
# Zsh Options (Modern Features)
# ------------------------------------------------------------------------------
# History options
setopt HIST_VERIFY              # Show command before execution
setopt SHARE_HISTORY            # Share history between sessions
setopt HIST_IGNORE_DUPS         # Ignore duplicate commands
setopt HIST_IGNORE_SPACE        # Ignore commands starting with space
setopt HIST_FIND_NO_DUPS        # Don't show duplicates in history search
setopt HIST_REDUCE_BLANKS       # Remove blank lines from history

# Navigation options
setopt AUTO_CD                  # cd by typing directory name
setopt AUTO_PUSHD               # Push directories to stack
setopt PUSHD_IGNORE_DUPS        # Don't push duplicates
setopt PUSHD_SILENT             # Don't print directory stack

# Completion options
setopt AUTO_LIST                # Show completion list
setopt AUTO_MENU                # Use menu completion
setopt COMPLETE_IN_WORD         # Complete in middle of words
setopt ALWAYS_TO_END            # Move cursor to end after completion

# Other useful options
setopt CORRECT                  # Spelling correction
setopt NO_BEEP                  # No beep on errors
setopt EXTENDED_GLOB            # Extended globbing
setopt MULTIOS                  # Multiple output redirection
setopt INTERACTIVE_COMMENTS     # Allow comments in interactive shell

# ------------------------------------------------------------------------------
# Enhanced Completion System
# ------------------------------------------------------------------------------
# Note: compinit is called by Oh My Zsh, so we don't call it again here
# We just configure completion styles

# Completion styles
zstyle ':completion:*' verbose yes
zstyle ':completion:*' group-name ''
zstyle ':completion:*:manuals' separate-sections true
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'  # Case insensitive
zstyle ':completion:*' menu select                      # Menu selection
zstyle ':completion:*' list-colors "${(@s.:.)LS_COLORS}" # Colors
zstyle ':completion:*:descriptions' format '%B%d%b'     # Format descriptions
zstyle ':completion:*:messages' format '%d'             # Format messages
zstyle ':completion:*:warnings' format 'No matches for: %d'
zstyle ':completion:*:corrections' format '%B%d (errors: %e)%b'

# ------------------------------------------------------------------------------
# Plugins (Optimized List)
# ------------------------------------------------------------------------------
plugins=(
  git
  docker
  docker-compose
  kubectl
  kubectx
  helm
  aws
  terraform
  tmux
  sudo
  aliases
  alias-finder
  history
  web-search
  systemadmin
  systemd
  compleat
  zsh-autosuggestions
  zsh-syntax-highlighting
)

# ------------------------------------------------------------------------------
# Source Oh My Zsh
# ------------------------------------------------------------------------------
source ${ZSH}/oh-my-zsh.sh

# ------------------------------------------------------------------------------
# Custom Prompt (Enhanced kphoen theme)
# ------------------------------------------------------------------------------
# Let the theme handle git prompts, but add timestamp
if [[ "$TERM" != "dumb" ]] && [[ "$DISABLE_LS_COLORS" != "true" ]]; then
    # Add timestamp to the left side (using %D{%T} for better performance)
    PROMPT='[%{$fg[red]%}%D{%T} %{$fg_bold[yellow]%}%n%{$reset_color%}@%{$fg[green]%}%m%{$reset_color%}:%{$fg[blue]%}%~%{$reset_color%}$(git_prompt_info)]
%# '

    # Keep the theme's git prompt settings
    ZSH_THEME_GIT_PROMPT_PREFIX=" on %{$fg[green]%}"
    ZSH_THEME_GIT_PROMPT_SUFFIX="%{$reset_color%}"
    ZSH_THEME_GIT_PROMPT_DIRTY=""
    ZSH_THEME_GIT_PROMPT_CLEAN=""

    # Display exit code on the right when >0
    return_code="%(?..%{$fg[red]%}%? ↵%{$reset_color%})"
    RPROMPT='${return_code}$(git_prompt_status)%{$reset_color%}'

    # Git status symbols
    ZSH_THEME_GIT_PROMPT_ADDED="%{$fg[green]%} ✚"
    ZSH_THEME_GIT_PROMPT_MODIFIED="%{$fg[blue]%} ✹"
    ZSH_THEME_GIT_PROMPT_DELETED="%{$fg[red]%} ✖"
    ZSH_THEME_GIT_PROMPT_RENAMED="%{$fg[magenta]%} ➜"
    ZSH_THEME_GIT_PROMPT_UNMERGED="%{$fg[yellow]%} ═"
    ZSH_THEME_GIT_PROMPT_UNTRACKED="%{$fg[cyan]%} ✭"
else
    # Fallback for dumb terminals
    PROMPT='[%D{%T} %n@%m:%~$(git_prompt_info)]
%# '
    RPROMPT='%(?..%? ↵)$(git_prompt_status)'
fi

# Position prompt at the bottom of the terminal
TPUT_END=$(tput cup 9999 0)
PS1="${TPUT_END}${PS1}"

# Vi mode indicator
function zle-line-init zle-keymap-select {
    VIM_PROMPT="%{${fg_bold[yellow]}%} [NORMAL] %{${reset_color}%}"
    RPS1="${${KEYMAP/vicmd/$VIM_PROMPT}/(main|viins)/} ${EPS1}"
    zle reset-prompt
}
zle -N zle-line-init
zle -N zle-keymap-select

# Fix for glob patterns - allows URLs with special chars without escaping
unsetopt nomatch

# ------------------------------------------------------------------------------
# Enhanced Aliases
# ------------------------------------------------------------------------------
# Navigation
alias cdg="cd ${USER_GIT_ROOT}"
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias ~="cd ~"

# Git shortcuts
alias g="git"
alias gs="git status"
alias ga="git add"
alias gc="git commit"
alias gp="git push"
alias gl="git log --oneline"
alias gd="git diff"
alias gco="git checkout"
alias gb="git branch"
alias gf="git fetch"
alias gm="git merge"

# System shortcuts
alias ll="ls -alF"
alias la="ls -A"
alias l="ls -CF"
alias vi="vim"
alias sz="source ${HOME}/.zshrc"
alias renner="cd ${HOME}/documents/renner"
alias scripts="cd ${HOME}/Documents/personal/scripts"

# Terraform shortcuts
alias tfinit="terraform init --reconfigure --upgrade"
alias tfplan="terraform plan"
alias tfapply="terraform apply"
alias tfdestroy="terraform destroy"
alias tfvalidate="terraform validate"
alias tffmt="terraform fmt -recursive"

# Docker shortcuts
alias d="docker"
alias dc="docker-compose"
alias dps="docker ps"
alias dpa="docker ps -a"
alias di="docker images"
alias dex="docker exec -it"

# Kubernetes shortcuts
alias k="kubectl"
alias kgp="kubectl get pods"
alias kgs="kubectl get services"
alias kgd="kubectl get deployments"
alias kdp="kubectl describe pod"
alias kds="kubectl describe service"
alias kdd="kubectl describe deployment"

# Claude Code plugins
alias claude-mem="$HOME/.bun/bin/bun $HOME/.claude/plugins/marketplaces/thedotmack/plugin/scripts/worker-service.cjs"

# Network utilities
alias ptpb="curl https://ptpb.pw -F c=@-"
alias myip="curl -s https://ipinfo.io/ip"
alias localip="ip route get 1.1.1.1 | awk '{print \$7; exit}'"

# VPN shortcuts
alias vpn="openvpn3 session-start --config vpn-agg"
alias vpnr="openvpn3 session-start --config vpn-repassa"

# Security-conscious system commands (renamed to avoid overriding system commands)
safe_shutdown() {
    echo "Are you sure you want to shutdown? (y/N)"
    read -q && sudo shutdown -h now
}

safe_reboot() {
    echo "Are you sure you want to reboot? (y/N)"
    read -q && sudo reboot now
}

# ------------------------------------------------------------------------------
# Enhanced Functions
# ------------------------------------------------------------------------------
# Environment setup with better error handling
envset() {
    if [ -d ${HOME}/git/zsh ]; then
        local pwd=$(pwd)
        echo "Updating zsh configuration..."
        cd ${HOME}/git/zsh
        
        if ! git pull origin; then
            echo "Error: Failed to pull latest changes"
            cd "${pwd}"
            return 1
        fi
        
        if ! git submodule update --recursive --init; then
            echo "Error: Failed to update submodules"
            cd "${pwd}"
            return 1
        fi
        
        cd "${pwd}"
    else
        echo "Error: zsh directory not found"
        return 1
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

# Enhanced tmux function
t() {
    local SESSIONNAME="main"
    # Check if not already inside a tmux session
    if [ -z "$TMUX" ]; then
        if ! tmux has-session -t "$SESSIONNAME" 2>/dev/null; then
            echo "Creating new tmux session: $SESSIONNAME"
            tmux new-session -s "$SESSIONNAME" -d
        fi
        tmux attach -t "$SESSIONNAME"
    else
        echo "Already in a tmux session: $TMUX"
    fi
}

# Create a new tmux session with a specific name
tn() {
    local session_name=${1:-$(basename $(pwd))}
    if [ -z "$TMUX" ]; then
        if tmux has-session -t "$session_name" 2>/dev/null; then
            echo "Session '$session_name' already exists. Attaching..."
            tmux attach -t "$session_name"
        else
            echo "Creating new tmux session: $session_name"
            tmux new-session -s "$session_name"
        fi
    else
        echo "Already in a tmux session: $TMUX"
    fi
}

# Quick directory creation and navigation
mkcd() {
    mkdir -p "$1" && cd "$1"
}

# Find files by name
ff() {
    find . -type f -name "*$1*" 2>/dev/null
}

# Find directories by name (renamed from 'fd' to avoid conflict with fd tool)
finddir() {
    find . -type d -name "*$1*" 2>/dev/null
}

# Extract various archive formats
extract() {
    if [ -f "$1" ]; then
        case "$1" in
            *.tar.bz2)   tar xjf "$1"     ;;
            *.tar.gz)    tar xzf "$1"     ;;
            *.bz2)       bunzip2 "$1"     ;;
            *.rar)       unrar e "$1"     ;;
            *.gz)        gunzip "$1"      ;;
            *.tar)       tar xf "$1"      ;;
            *.tbz2)      tar xjf "$1"     ;;
            *.tgz)       tar xzf "$1"     ;;
            *.zip)       unzip "$1"       ;;
            *.Z)         uncompress "$1"  ;;
            *.7z)        7z x "$1"        ;;
            *)           echo "'$1' cannot be extracted via extract()" ;;
        esac
    else
        echo "'$1' is not a valid file"
    fi
}

# Git log with graph (override git plugin's glog alias with enhanced version)
unalias glog 2>/dev/null
glog() {
    git log --graph --pretty=format:'%Cred%h%Creset -%C(yellow)%d%Creset %s %Cgreen(%cr) %C(bold blue)<%an>%Creset' --abbrev-commit "$@"
}

# ------------------------------------------------------------------------------
# Performance Optimizations
# ------------------------------------------------------------------------------
# Lazy load kubectl completion for faster startup
if command -v kubectl &> /dev/null; then
    kubectl() {
        unfunction kubectl
        source <(command kubectl completion zsh)
        kubectl "$@"
    }
fi

# ------------------------------------------------------------------------------
# Initializations
# ------------------------------------------------------------------------------
# Source local configuration if it exists
[ -f ${HOME}/.localrc ] && source ${HOME}/.localrc

# Initialize mcfly (command history search) if available
if command -v mcfly &> /dev/null; then
    eval "$(mcfly init zsh)"
fi

# Initialize Homebrew if available
if [ -x /home/linuxbrew/.linuxbrew/bin/brew ]; then
    eval "$(/home/linuxbrew/.linuxbrew/bin/brew shellenv)"
fi

# Initialize mise (version manager) if available
if command -v mise &> /dev/null; then
    eval "$(mise activate zsh)"
fi

# Initialize Bun completions if available
[ -s "$HOME/.bun/_bun" ] && source "$HOME/.bun/_bun"

# Initialize Oracle CLI autocompletion if available
OCI_AUTOCOMPLETE="${HOME}/lib/oracle-cli/lib/python3.12/site-packages/oci_cli/bin/oci_autocomplete.sh"
[[ -e "${OCI_AUTOCOMPLETE}" ]] && source "${OCI_AUTOCOMPLETE}"

# Show profiling results if enabled (uncomment zprof at the top to enable)
# zprof
