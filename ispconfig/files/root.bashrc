# .bashrc

# User specific aliases and functions

alias rm='rm -i'
alias cp='cp -i'
alias mv='mv -i'

# Source global definitions
if [ -f /etc/bashrc ]; then
	. /etc/bashrc
fi

PS1='\[\e[0;32m\]\u@\h\[\e[m\]:\[\e[0;34m\]\w\[\e[m\]\[\e[0;32m\]\$\[\e[0;37m\] '

PATH=$PATH":/root/bin:/usr/local/bin"
HISTSIZE=10000
HISTFILESIZE=10000
HISTTIMEFORMAT="%b %d %H:%M:%S   "
