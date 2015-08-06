# Lines configured by zsh-newuser-install
HISTFILE=~/.zshhistfile
HISTSIZE=5000
SAVEHIST=5000
# End of lines configured by zsh-newuser-install

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

if  [ $USER = 'root' ]
then
    export prompt='%n@%m (%2~) > '
else
    export prompt='%m (%2~) > '
fi

if [ -d /home/chris/bin ]
then
   export PATH=/home/chris/bin:$PATH:/sbin:/usr/sbin
fi

if [ -d /home/chris/code/bin ]
then
   export PATH=$PATH:/home/chris/code/bin/search:/home/chris/code/bin/imagesys
   export PATH=$PATH:/home/chris/code/bin/etl
   export PATH=$PATH:/home/chris/code/bin/database
   export PATH=$PATH:/home/chris/code/bin/daemons
fi

setopt incappendhistory histexpiredupsfirst histignoredups
setopt autocd notify
unsetopt beep
setopt list_packed
setopt sh_word_split

alias ls="ls --color=auto -F"

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
    if [ "$1" != "" -a -f $1 ]
    then
        builtin cd `dirname $1`
    else
        builtin cd $@
    fi
}

# My find | xargs grep to avoid .svn directories
alias fn="egrep --binary-files=without-match -r"

lc() {
    search_term=$1
    locate $1 | grep -v .git
}

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

# Perl stack trace on die
export PERL5OPT="-Mdiagnostics=-traceonly"

### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 
[[ -r $HOME/.rvm/scripts/completion ]] && . $HOME/.rvm/scripts/completion

# Ruby
alias rt="rake test TESTOPTS=-v"
