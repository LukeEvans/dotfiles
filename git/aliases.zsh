alias change-commits="!f() { VAR=$1; OLD=$2; NEW=$3; shift 3; git filter-branch --env-filter \"if [[ \\\"$`echo $VAR`\\\" = '$OLD' ]]; then export $VAR='$NEW'; fi\" $@; }; f "

alias gs='git status'
alias gp='git pull'
alias gh='git push'
alias gempty='git commit --allow-empty -m "Trigger Jenkins"'

function gprco() {
	git fetch upstream pull/$1/head:pr/$1 && git checkout pr/$1
}
