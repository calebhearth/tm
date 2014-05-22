tm() {
  if [ -z "$TMUX" ]; then
    # not in tmux
    tmux new-session -As $1
  else
    # inside tmux
    if [ tmux has-session $1 ]; then
      tmux switch-client -t $1
    else
      TMUX= tmux new-session -ds $1
      tmux switch-client -t $1
    fi
 fi
}