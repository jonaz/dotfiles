
# If not running interactively, don't do anything
[[ $- != *i* ]] && return

export GOPATH=$HOME/go
export PATH=$HOME/.cargo/bin:$PATH:$GOPATH/bin:$HOME/bin

export SSH_AUTH_SOCK="${XDG_RUNTIME_DIR}/ssh-agent.socket"

# copied from /etc/bash.bashrc and added alacritty*
case ${TERM} in
  xterm*|rxvt*|Eterm|alacritty*|aterm|kterm|gnome*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033]0;%s@%s:%s\007" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'

    ;;
  screen*)
    PROMPT_COMMAND=${PROMPT_COMMAND:+$PROMPT_COMMAND; }'printf "\033_%s@%s:%s\033\\" "${USER}" "${HOSTNAME%%.*}" "${PWD/#$HOME/\~}"'
    ;;
esac


VIM_COMMAND="vim"
if type "nvim" > /dev/null; then
	VIM_COMMAND="nvim"
fi

#functions for aliases
customgrepinfile() {
	rg -i --vimgrep "$1" . | $VIM_COMMAND -c "set noro" -c "noremap <enter> <C-w>F" -c "/$1" -R -
}

customgrepfilename() {
	local file
	file=$(fzf --query="$1" --select-1 --exit-0)
	[ -n "$file" ] && ${EDITOR:-$VIM_COMMAND} "$file"
}

# open lastpass for search in fzf and copy selected to clipboard
p(){
	lpass show -c --password "$(lpass ls -l |fzf | grep -Po "\[id: (.+)\] " | awk '{print $2}' |  sed 's/\]//g')"
	echo "Copied password to clipboard"
}

vimj(){
	nvim -c 'silent execute "normal! p"' -c "silent JsonPretty"
}

vimc(){
	nvim -c "silent CurlOpen collection global slask" -c 'silent execute "normal! G2o"' -c 'execute "normal! p"'
}
vimx(){
	nvim -c 'silent execute "normal! p"' -c "silent XmlPretty"
}

kssh(){
    if  [ -z "$1" ]; then
	    node=$(kubectl get node --no-headers=true | fzf | awk '{print $1}')
    else 
	    node=$(kubectl --context $1 get node --no-headers=true | fzf | awk '{print $1}')
	fi
    ssh "$node"
}

mkssh(){
	nodes=$(kubectl get node --no-headers=true | grep $1 | awk '{print $1}')
	while IFS= read -r node; do
		echo "ssh into $node"
		urxvt -e "bash" -c "ssh $node; bash" &
	done <<< "$nodes"
}

git-remove-orphan-branches(){
	git fetch -p
	git branch -vv | grep "gone]" | grep -v "\*" | awk '{print $1}' | xargs -r git branch -d
}
git-list-orphan-branches(){
	git fetch -p
	git branch -vv | grep "gone]" | grep -v "\*"
}

#aliases
alias f=customgrepinfile
alias fn=customgrepfilename
alias ll="ls -lhstr"
alias gd="git diff"

# if we have nvim alias vim to it
alias vim='nvim'
alias vimdiff='nvim -d'


#settings
export EDITOR="$VIM_COMMAND"
export BROWSER=google-chrome-stable
HISTTIMEFORMAT='%F %T - '
stty ixany
stty ixoff -ixon
HISTCONTROL=ignoreboth
HISTSIZE=100000
HISTFILESIZE=10000000


# Enable history appending instead of overwriting.
shopt -s histappend
PROMPT_COMMAND="${PROMPT_COMMAND:+$PROMPT_COMMAND$'\n'}history -a; history -n"

export LPASS_AGENT_TIMEOUT=28800

# Bash won't get SIGWINCH if another process is in the foreground.
# Enable checkwinsize so that bash will check the terminal size when
# it regains control.
# http://cnswww.cns.cwru.edu/~chet/bash/FAQ (E11)
shopt -s checkwinsize


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


source ~/bin/kube-ps1.sh

k(){
	if [[ $PS1 = *"kube_ps1"* ]]; then
		ps1_normal
	else
		ps1_kube
	fi
}

ps1_normal() {
	PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[$RED\]\h'; else echo '\[$GREEN\]\u@\h'; fi)\[\$BLUE\] \w \$([[ \$? != 0 ]] && echo \"\[\$RED\]:( \")\[$CYAN\]\$(__git_ps1 '[%s]') \[$BASE2\]\n\$\[$RESET\] "
}

ps1_kube() {
	KUBE_PS1_PREFIX="["
	KUBE_PS1_SUFFIX="]"
	KUBE_PS1_SYMBOL_ENABLE=false
	PS1="$(if [[ ${EUID} == 0 ]]; then echo '\[$RED\]\h'; else echo '\[$GREEN\]\u@\h'; fi)\[\$BLUE\] \w \$([[ \$? != 0 ]] && echo \"\[\$RED\]:( \")\[$CYAN\]\$(__git_ps1 '[%s]') \$(kube_ps1) \[$BASE2\]\n\$\[$RESET\] "
}

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
	ps1_normal


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



# GIT heart FZF
# -------------

export FZF_DEFAULT_COMMAND="rg --files"

is_in_git_repo() {
  git rev-parse HEAD > /dev/null 2>&1
}

fzf-down() {
  fzf --height 50% "$@" --border
}

gf() {
  is_in_git_repo || return
  local file
  file=$(git -c color.status=always status --short | fzf-down --select-1 -m --ansi --nth 2..,.. --preview '(git diff --color=always -- {-1} | sed 1,4d; cat {-1}) | head -500' | cut -c4- | sed 's/.* -> //')
  [ -n "$file" ] && ${EDITOR:-$VIM_COMMAND} "$file"
}

gb() {
  is_in_git_repo || return
  git branch -a --color=always | grep -v '/HEAD\s' | sort |
  fzf-down --ansi --multi --tac --preview-window right:70% \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" $(sed s/^..// <<< {} | cut -d" " -f1) | head -'$LINES |
  sed 's/^..//' | cut -d' ' -f1 |
  sed 's#^remotes/##'
}

gt() {
  is_in_git_repo || return
  git tag --sort -version:refname |
  fzf-down --multi --preview-window right:70% \
    --preview 'git show --color=always {} | head -'$LINES
}

gh() {
  is_in_git_repo || return
  git log --date=short --format="%C(green)%C(bold)%cd %C(auto)%h%d %s (%an)" --graph --color=always |
  fzf-down --ansi --no-sort --reverse --multi --bind 'ctrl-s:toggle-sort' \
    --header 'Press CTRL-S to toggle sort' \
    --preview 'grep -o "[a-f0-9]\{7,\}" <<< {} | xargs git show --color=always | head -'$LINES |
  grep -o "[a-f0-9]\{7,\}"
}

gr() {
  is_in_git_repo || return
  git remote -v | awk '{print $1 "\t" $2}' | uniq |
  fzf-down --tac \
    --preview 'git log --oneline --graph --date=short --pretty="format:%C(auto)%cd %h%d %s" {1} | head -200' |
  cut -d$'\t' -f1
}

bind '"\er": redraw-current-line'
bind '"\C-g\C-f": "gf\n"'
bind '"\C-g\C-b": "$(gb)\e\C-e\er"'
bind '"\C-g\C-t": "$(gt)\e\C-e\er"'
bind '"\C-g\C-h": "$(gh)\e\C-e\er"'
bind '"\C-g\C-r": "$(gr)\e\C-e\er"'
bind '"\C-g\C-d": "git diff\n"'
bind '"\C-g\C-s": "git status\n"'
bind '"\C-g\C-l": "git log\n"'
bind '"\C-v\C-v": "nvim\n"'


#fnm
eval "$(fnm env --shell bash)"

