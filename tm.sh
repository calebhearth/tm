#!/bin/zsh

tm() {
  if [ -z $1 ]; then
    tmux switch-client -l
    exit
  fi

  local WORKING_DIRECTORY=$(cdpath=(. ~/code) cd $1 > /dev/null 2>&1 && pwd)
  if [ -z "$TMUX" ]; then
    if [ -n "$WORKING_DIRECTORY" ]; then
      tmux new-session -As $1 -c $WORKING_DIRECTORY
    else
      tmux new-session -As $1 -c $HOME
    fi
  else
    if tmux has-session -t $1 2> /dev/null; then
      tmux switch-client -t $1
    else
      if [ -n "$WORKING_DIRECTORY" ]; then
        TMUX= tmux new-session -ds $1 -c $WORKING_DIRECTORY
      else
        TMUX= tmux new-session -ds $1
      fi
      tmux switch-client -t $1
    fi
  fi
}

tm $1
