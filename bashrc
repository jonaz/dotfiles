
# If not running interactively, don't do anything
[[ $- != *i* ]] && return


HAS_NVIM=false
VIM_COMMAND="vim"
if type "nvim" > /dev/null; then
	HAS_NVIM=true
	VIM_COMMAND="nvim"
fi

#functions for aliases
customgrepinfile() {
	grep -r "$1" * | $VIM_COMMAND -c "noremap <enter> <C-w>f<cr>" -c "/$1" -R -
}
customgrepfilename() {
    #find . | grep $1 | vim -c "noremap <enter> <C-w>f<cr>" -c "/$1" -R -
	local file
	file=$(fzf --query="$1" --select-1 --exit-0)
	[ -n "$file" ] && ${EDITOR:-$VIM_COMMAND} "$file"
}

gitstatusopenfiles() {
	$VIM_COMMAND -O $(git status -s | awk '{print $2}')
}
gitstatusfind() {
	git status -s | $VIM_COMMAND -c "noremap <enter> <C-w>f<cr>" -R -
}


#aliases
alias f=customgrepinfile
alias fn=customgrepfilename
alias ll="ls -lhstr"
alias svndiff="svn diff | vim -R -"

# if we have nvim alias vim to it
if $HAS_NVIM ; then
  alias vim='nvim'
fi


#settings
export EDITOR="$VIM_COMMAND"
export HISTTIMEFORMAT='%F %T - '
stty ixany
stty ixoff -ixon
export HISTCONTROL=ignoredups
export HISTCONTROL=ignoreboth
export HISTSIZE=10000

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize





case ${TERM} in
	xterm*|rxvt*|Eterm|aterm|kterm|gnome*)
		PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
		;;
	screen)
		PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/~}"'
		;;
esac


# Enable history appending instead of overwriting.
shopt -s histappend
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -c; history -r"

# Set colorful PS1 only on colorful terminals.
# dircolors --print-database uses its own built-in database
# instead of using /etc/DIR_COLORS. Try to use the external file
# first to take advantage of user additions. Use internal bash
# globbing instead of external grep binary.

# sanitize TERM:
safe_term=${TERM//[^[:alnum:]]/?}
match_lhs=""

[[ -f ~/.dir_colors ]] && match_lhs="${match_lhs}$(<~/.dir_colors)"
[[ -f /etc/DIR_COLORS ]] && match_lhs="${match_lhs}$(</etc/DIR_COLORS)"
[[ -z ${match_lhs} ]] \
	&& type -P dircolors >/dev/null \
	&& match_lhs=$(dircolors --print-database)


#export GIT_PS1_SHOWDIRTYSTATE=1
#export GIT_PS1_SHOWUPSTREAM="auto"
#for arch only. debian have this autoincluded.
[[ -f /usr/share/git/completion/git-prompt.sh ]] && source /usr/share/git/completion/git-prompt.sh

if [[ $'\n'${match_lhs} == *$'\n'"TERM "${safe_term}* ]] ; then
	# we have colors :-)

    #solarized dark colors
    BASE03=$(tput setaf 234)
    BASE02=$(tput setaf 235)
    BASE01=$(tput setaf 240)
    BASE00=$(tput setaf 241)
    BASE0=$(tput setaf 244)
    BASE1=$(tput setaf 245)
    BASE2=$(tput setaf 254)
    BASE3=$(tput setaf 230)
    YELLOW=$(tput setaf 136)
    ORANGE=$(tput setaf 166)
    RED=$(tput setaf 160)
    MAGENTA=$(tput setaf 125)
    VIOLET=$(tput setaf 61)
    BLUE=$(tput setaf 33)
    CYAN=$(tput setaf 37)
    GREEN=$(tput setaf 64)
    BOLD=$(tput bold)
    RESET=$(tput sgr0)

	# Enable colors for ls, etc. Prefer ~/.dir_colors
	if type -P dircolors >/dev/null ; then
		if [[ -f ~/.dir_colors ]] ; then
			eval $(dircolors -b ~/.dir_colors)
		elif [[ -f /etc/DIR_COLORS ]] ; then
			eval $(dircolors -b /etc/DIR_COLORS)
		fi
	fi
    #man pages colors
    export LESS_TERMCAP_mb=$(echo -e "$RED") # 'blinking' text
    export LESS_TERMCAP_md=$(echo -e "$BLUE") # 'bold' text
    export LESS_TERMCAP_us=$(echo -e "$GREEN") # 'underlined' text
    export LESS_TERMCAP_ue=$(echo -e "$BASE0") # end 'underlined' text
    export LESS_TERMCAP_so=$(echo -e "$BASE2") # standout mode
    export LESS_TERMCAP_se=$(echo -e "$BASE0") # end 'standout' mode
    export LESS_TERMCAP_me=$(echo -e "$BASE0") # end appearance modes

	alias ls="ls --color=auto"
	alias dir="dir --color=auto"
	alias grep="grep --color=auto"
	alias dmesg='dmesg --color'
	PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[$RED\]\h'; else echo '\[$GREEN\]\u@\h'; fi)\[\$BLUE\] \w \$([[ \$? != 0 ]] && echo \"\[\$RED\]:( \")\[$CYAN\]\$(__git_ps1 '[%s]') \[$BASE2\]\$\[$RESET\] "


else
	# show root@ when we do not have colors
	PS1="\u@\h \w \$([[ \$? != 0 ]] && echo \":( \")\$ "
	# Use this other PS1 string if you want \W for root and \w for all other users:
	# PS1="\u@\h $(if [[ ${EUID} == 0 ]]; then echo '\W'; else echo '\w'; fi) \$([[ \$? != 0 ]] && echo \":( \")\$ "

fi

PS2="> "
PS3="> "
PS4="+ "

# Try to keep environment pollution down, EPA loves us.
unset safe_term match_lhs

# Try to enable the auto-completion (type: "pacman -S bash-completion" to install it).
[ -r /usr/share/bash-completion/bash_completion ] && . /usr/share/bash-completion/bash_completion

# Try to enable the "Command not found" hook ("pacman -S pkgfile" to install it).
# See also: https://wiki.archlinux.org/index.php/Bash#The_.22command_not_found.22_hook
[ -r /usr/share/doc/pkgfile/command-not-found.bash ] && . /usr/share/doc/pkgfile/command-not-found.bash
