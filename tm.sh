#!/bin/sh
tm() {
  if [ -z $1 ]; then
    target_session=$(cat /tmp/previous-tmux-session)
    tm $target_session
  else
    if [ -z "$TMUX" ]; then
      tmux new-session -As $1
    else
      record_previous_session
      if ! tmux has-session -t $1 2>/dev/null; then
        TMUX= tmux new-session -ds $1
      fi
      tmux switch-client -t $1
    fi
  fi
}

record_previous_session() {
  current_session=$(tmux list-sessions | grep '(attached)$' | cut -d: -f 1)
  echo $current_session > /tmp/previous-tmux-session
}

tm $1