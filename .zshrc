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

PATH=$PATH:/opt/lokku/bin

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

# Lokku specific


# Standard WigWam/Lokku aliases
# rebuild conf
alias bct='wigdo ~/code/bin/wigwam/build_config_tree.sh'

_myhup() {
    if [ ! -f $1 ]
    then
        echo "No such file: $1"
    else
        pid=`cat $1`
        if [ -z "$pid" -o ! -d "/proc/$pid" ]
        then
            echo "Not a valid process or no such process: $pid"
        else
            CMD="kill -s HUP $pid"
            echo $CMD
            $CMD
        fi
    fi
}

# HUP frontend frontend-static search-api
alias hf="_myhup ~/common/run/frontend.pid"
alias hfs="_myhup ~/common/run/frontend-static.pid"
alias hsa="_myhup ~/common/run/search-api.pid"

# tail frontend
alias tfa='tail -f ~/common/logs/apache/frontend/access_log.`date +%Y-%m-%d`*'
alias tfe='tail -f ~/common/logs/apache/frontend/error_log.`date +%Y-%m-%d`*'
 
# tail frontend static
alias tfsa='tail -f ~/common/logs/apache/frontend-static/access_log.`date +%Y-%m-%d`*'
alias tfse='tail -f ~/common/logs/apache/frontend-static/error_log.`date +%Y-%m-%d`*'

# tail frontend static
alias tsa='tail -f ~/common/logs/apache/search-api/access_log.`date +%Y-%m-%d`*'
alias tse='tail -f ~/common/logs/apache/search-api/error_log.`date +%Y-%m-%d`*'

# tail sim log
alias ts="tail -f ~/common/logs/sim/sim-server.log"

# Chris aliases
alias wp='echo wigdo prove ; wigdo prove'
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
    locate $1 | grep -v .svn
}

# Find but ignore .svn 
f() {

    # Simple case of just one arg then we just find | grep
    if [ $# -eq 1 ]
    then
        1>&2 echo 'find . -name .svn -prune -or -print | grep "$@"' 
        find . -name .svn -prune -or -print | grep "$@"
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
        1>&2 echo find $PATHS -name .svn -prune -or "$@"
        find $PATHS -name .svn -prune -or "$@" 
    else
        find $PATHS -name .svn -prune -or -print
    fi
}

alias idb="mysql -u root --socket ~/common/run/mysql-infra-db.sock"
alias ldb="mysql -u root --socket ~/common/run/mysql-listings-db.sock"
alias sdb="mysql -u root --socket ~/common/run/mysql-search-db.sock"
alias mdb="mysql -u root --socket ~/common/run/mysql-metrics-db.sock"
alias udb="mysql -u root --socket ~/common/run/mysql-users-db.sock"

alias all_servers="perl -MLokku::Base::Config -le 'print join(\" \", sort keys %{ Lokku::Base::Config->get(qw(servers prod)) });'"

export XAUTHORITY=~/.Xauthority

export LOKKU_BASE_CONFIG_AUTO_REBUILD=1

fd() {
    ls -l /proc/$1/fd
}

# Perl stack trace on die
export PERL5OPT="-Mdiagnostics=-traceonly"

# perlcritic
alias pc="perlcritic --verbose=11 --profile=$HOME/code/conf/dev/perlcriticrc"


### Added by the Heroku Toolbelt
export PATH="/usr/local/heroku/bin:$PATH"

export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting

[[ -s "$HOME/.rvm/scripts/rvm" ]] && . "$HOME/.rvm/scripts/rvm" 
[[ -r $HOME/.rvm/scripts/completion ]] && . $HOME/.rvm/scripts/completion
