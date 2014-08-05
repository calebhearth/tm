#!/bin/zsh

readonly PROGNAME=$(basename $0)
readonly ARGS="$@"

usage() {
	cat <<EOS
usage: $PROGNAME [--help] [session name]

Easily switch between, create, or attach to a TMUX(1) session by name.

OPTIONS:
	--help		Show this help text.

Examples:
	Switch to the previous session (from with a tmux session):
	$PROGNAME

	Attach to a session:
	$PROGNAME existing-session-name

	Create a new session:
	$PROGNAME new-session-name
EOS
}

noArguments() {
	[[ -z $ARGS ]];
}

toggleLastSession() {
	tmux switch-client -l;
}

inTmux() {
	[[ -n "$TMUX" ]]
}

sessionExists() {
	local sessionName=$1
	tmux has-session -t "$sessionName" 2> /dev/null;
}

attachToSession() {
	local sessionName=$1
	tmux switch-client -t "$sessionName"
}

isDirectoryInPath() {
	[[ -n "$WORKING_DIRECTORY" ]];
}

createSession() {
	local sessionName=$1
	if isDirectoryInPath $sessionName; then
		TMUX= tmux new-session -ds $1 -c $WORKING_DIRECTORY
	else
		TMUX= tmux new-session -ds $1
	fi
}

isUnset() {
	local variable=$1
	[[ -z $variable ]];
}

workingDirectory() {
	if isUnset $WORKING_DIRECTORY; then
		local directoryName=$1
		WORKING_DIRECTORY=$(
		cdpath=(. ~/code);
		cd $directoryName > /dev/null 2>&1
		pwd
		)
	fi
	return $WORKING_DIRECTORY
}

switchFromInsideTmux() {
	local $sessionname=$1

	if sessionExists $sessionName; then
		attachToSession $sessionName;
	else
		createSession $sessionName
		attachToSession $sessionName
	fi
}

createSessionInDirectory() {
	local sessionName=$1
	local workingDirectory=$2
	tmux new-session -As $sessionName -c $workingDirectory
}

switchFromOutsideTmux() {
	local wd=workingDirectory $sessionName
	if isDirectoryInPath $wd; then
		createSessionInDirectory $sessionName $wd
	else
		createSessionInDirectory $sessionName $HOME
	fi
}

switchToSession() {
	local sessionName=$1
	if inTmux; then
		switchFromInsideTmux $sessionName
	else
		switchFromOutsideTmux $sessionName
	fi
}

case $1 in
"") toggleLastSession;;
"--help") usage;;
*) switchToSession $1;;
esac
