#!/bin/bash
# vim: filetype=sh
# set -u

# Set default permissions
# User can do anything
# Group can read + execute
# Others can't do anything
umask 027

now() {
	date +%s%N
}
# Capture beginning of run time
start="$(now)"

time_since(){
	diff="$(($(date +%s%N)-$1))"
	# Drop nanoseconds through milliseconds (/10**9)
	seconds=$((diff/10**9))
	# Drop us to ns (/10**6), then truncate above ms (%10**3)
	ms=$((diff/10**6%10**3))
	printf "%d.%.3d seconds\n" ${seconds} ${ms}
}

time_until() {
 local date="$1"

  echo $((($(date +%s --date "$date")-$(date +%s))/(3600*24)))
}

#
# Countdowns
#
# echo "T-Jonas's new school: $(time_until '2025-09-08') days"


# Baseline my PATH
BASEPATH="/usr/local/sbin:/usr/local/bin:/usr/sbin:/usr/bin:/sbin:/bin:/snap/bin:/snap/bin"
reset_path(){
    export PATH=${BASEPATH}
}; reset_path

if [ -d ~/.local/bin ]; then
    export PATH="${HOME}/.local/bin:${PATH}"
fi

# NOTE) Too powerful.
# if [ -d "${HOME}/.local/opt" ]; then
# 	for path in ${HOME}/.local/opt/**/bin; do
# 		export PATH="${PATH}:$path"
# 	done
# fi

#echo "PATH+profile) $PATH"

pre_bashrc=$(now)
. ~/.bashrc
printf "Loaded .bashrc in %s\n" "$(time_since "$pre_bashrc")"
#echo "PATH+rc) $PATH"

if [ -f ~/.bash_aliases ]; then
  pre_aliases=$(now)
  . ~/.bash_aliases
  printf "Loaded .bash_aliases in %s\n" "$(time_since "$pre_aliases")"
  #echo "PATH+aliases) $PATH"
fi

# wait "$pending_pid"
# cat tasks
# ? How to close 'tasks'?

# echo "Week $(date +%W)"

