# Path to your oh-my-zsh installation.
export ZSH=/home/chris/.oh-my-zsh

# Set name of the theme to load.
# Look in ~/.oh-my-zsh/themes/
# Optionally, if you set this to "random", it'll load a random theme each
# time that oh-my-zsh is loaded.
ZSH_THEME="chris"

# Uncomment the following line to use case-sensitive completion.
# CASE_SENSITIVE="true"

# Uncomment the following line to use hyphen-insensitive completion. Case
# sensitive completion must be off. _ and - will be interchangeable.
# HYPHEN_INSENSITIVE="true"

# Uncomment the following line to disable bi-weekly auto-update checks.
# DISABLE_AUTO_UPDATE="true"

# Uncomment the following line to change how often to auto-update (in days).
# export UPDATE_ZSH_DAYS=13

# Uncomment the following line to disable colors in ls.
# DISABLE_LS_COLORS="true"

# Uncomment the following line to disable auto-setting terminal title.
# DISABLE_AUTO_TITLE="true"

# Uncomment the following line to enable command auto-correction.
# ENABLE_CORRECTION="true"

# Uncomment the following line to display red dots whilst waiting for completion.
# COMPLETION_WAITING_DOTS="true"

# Uncomment the following line if you want to disable marking untracked files
# under VCS as dirty. This makes repository status check for large repositories
# much, much faster.
DISABLE_UNTRACKED_FILES_DIRTY="true"

# Uncomment the following line if you want to change the command execution time
# stamp shown in the history command output.
# The optional three formats: "mm/dd/yyyy"|"dd.mm.yyyy"|"yyyy-mm-dd"
# HIST_STAMPS="mm/dd/yyyy"

# Would you like to use another custom folder than $ZSH/custom?
# ZSH_CUSTOM=/path/to/new-custom-folder

# Which plugins would you like to load? (plugins can be found in ~/.oh-my-zsh/plugins/*)
# Custom plugins may be added to ~/.oh-my-zsh/custom/plugins/
# Example format: plugins=(rails git textmate ruby lighthouse)
# Add wisely, as too many plugins slow down shell startup.
plugins=(git heroku)

# User configuration

HISTFILE=~/.zshhistfile
HISTSIZE=10000
SAVEHIST=10000

if [ $(whence dircolors) ]; then

    if [ -f ~/.dircolors ]; then
        eval $(dircolors -b ~/.dircolors)
    else
        eval $(dircolors -b)
    fi
fi

# The following lines were added by compinstall

zstyle ':completion:*' completer _complete _ignored _correct _approximate _prefix
zstyle ':completion:*' expand suffix
zstyle ':completion:*' ignore-parents parent pwd ..
zstyle ':completion:*' list-colors ${(s.:.)LS_COLORS}
zstyle ':completion:*' list-prompt %SAt %p: Hit TAB for more, or the character to insert%s
zstyle ':completion:*' list-suffixes true
zstyle ':completion:*' max-errors 2
zstyle ':completion:*' preserve-prefix '//[^/]##/'
zstyle :compinstall filename '/home/chris/.zshrc'

autoload -Uz compinit
compinit
# End of lines added by compinstall

setopt incappendhistory histexpiredupsfirst histignoredups
setopt autocd notify
unsetopt beep
setopt list_packed
setopt sh_word_split


em() {
    emacs $* &
}

export LESS="-i -P%f %lt-%lb/%L ?m(%i/%m)."

alias more="less"

alias egrep='egrep --color=tty -d skip'
alias egrpe='egrep --color=tty -d skip'
alias fgrep='fgrep --color=tty -d skip'
alias fgrpe='fgrep --color=tty -d skip'
alias grep='grep --color=tty -d skip'
alias grpe='grep --color=tty -d skip'

export SVN_EDITOR='emacs'

# This is to get xemacs tramp working
[[ $TERM == "dumb" ]] && unsetopt zle && PS1='$ '

cd() {
    if [ "$1" != "" -a -f "$1" ]
    then
        builtin cd `dirname '$1'`
    else
        builtin cd "$@"
    fi
}

# My find | xargs grep to avoid .svn directories
alias fn="egrep --binary-files=without-match -r"

# Find but ignore .git
f() {

    # Simple case of just one arg then we just find | grep
    if [ $# -eq 1 ]
    then
        1>&2 echo 'find . -name .git -prune -or -print | grep "$@"'
        find . -name .git -prune -or -print | grep "$@"
        return
    fi

    PATHS=
    while [ "$1" != "" -a "$(echo $1 | cut -c1)" != "-" ]
    do
      PATHS="$PATHS $1"
      shift
    done

    if [ $# -gt 0 ]
    then
        1>&2 echo find $PATHS -name .git -prune -or "$@"
        find $PATHS -name .git -prune -or "$@"
    else
        find $PATHS -name .git -prune -or -print
    fi
}

export XAUTHORITY=~/.Xauthority

fd() {
    ls -l /proc/$1/fd
}

export PATH="$HOME/bin:$PATH"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export NVM_DIR="/home/chris/.nvm"
[ -s "$NVM_DIR/nvm.sh" ] && . "$NVM_DIR/nvm.sh"  # This loads nvm

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm"
[[ -r $HOME/.rvm/scripts/completion ]] && . $HOME/.rvm/scripts/completion

my-rvm-prompt() {
    GPI=$(git_prompt_info)
    if [ "$GPI" != "" ]
    then
        #RPROMPT=$(rvm-prompt | sed -e 's/^ruby-//')
        #echo '('$RPROMPT/$GPI
        echo '('$GPI
    fi
}

source $ZSH/oh-my-zsh.sh

# You may need to manually set your language environment
# export LANG=en_US.UTF-8

# Preferred editor for local and remote sessions
# if [[ -n $SSH_CONNECTION ]]; then
#   export EDITOR='vim'
# else
#   export EDITOR='mvim'
# fi

# Compilation flags
# export ARCHFLAGS="-arch x86_64"

# ssh
# export SSH_KEY_PATH="~/.ssh/dsa_id"

# Set personal aliases, overriding those provided by oh-my-zsh libs,
# plugins, and themes. Aliases can be placed here, though oh-my-zsh
# users are encouraged to define aliases within the ZSH_CUSTOM folder.
# For a full list of active aliases, run `alias`.
#
# Example aliases
# alias zshconfig="mate ~/.zshrc"
# alias ohmyzsh="mate ~/.oh-my-zsh"

source ~/.zshrc_private
