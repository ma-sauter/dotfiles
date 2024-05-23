#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export EDITOR=vim

PS1='[\u@\h \W]\$ '

eval "$(starship init bash)"

echo ""
pfetch

#########################
# Custom Aliases        #
#########################
alias ls='ls --color=auto'
alias grep='grep --color=auto'
alias config='/usr/bin/git --git-dir=/home/marc/.myconfig/.git --work-tree=/home/marc/'

#########################
# PATH                  #
#########################
export PATH="/usr/local/texlive/2024/bin/x86_64-linux:$PATH"
