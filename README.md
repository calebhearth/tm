# tm

Easy tmux session switching,
creation,
and toggling.

## Usage

    tm mysession
    tm [dir in cdpath] # if new session, set working-directory for all new shells

Whether or not you are in tmux,
the tm function
will switch to the given session
if it already exists.
If it doesn't already exist,
it will create it
and then switch to it.

Included in /contrib
are bash and zsh tab-completions
for existing tmux session names.

Jon Yurek found the basics
of this function
somewhere on the Internet.
The original author
could not be found.

## Toggle between the last two sessions

Add these mappings
to ~/.tmux.conf

    bind m switch-client -l
    bind M command-prompt -p 'switch session:' "run \"tm '%%'\""

## Tab completion

Bash tab completion
is in `completion.bash`.

Zsh tab completion
is in `_tm`.

* Copy `_tm`
  somewhere in your `fpath`.
* Run `autoload -U compinit`
  and `compinit`
  after `_tm` is added
  to your `fpath`.
