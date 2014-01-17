
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

#functions for aliases
customgrepinfile() {
    grep -r $1 * | vim -c "noremap <enter> <C-w>f<cr>" -c "/$1" -R -
}
customgrepfilename() {
    find . | grep $1 | vim -c "noremap <enter> <C-w>f<cr>" -c "/$1" -R -
}

alias f=customgrepinfile
alias fn=customgrepfilename
alias svndiff="svn diff | vim -R -"

export EDITOR="vim"
export HISTTIMEFORMAT='%F %T - '
