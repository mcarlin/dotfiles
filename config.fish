starship init fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here
end

function nvm
   bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

set -x NVM_DIR ~/.nvm
nvm use default --silent

alias vim "nvim"

# Setting PATH for Python 3.11
# The original version is saved in /Users/carlinm/.config/fish/config.fish.pysave
set -x PATH "/Library/Frameworks/Python.framework/Versions/3.11/bin" "$PATH"

function wr -a FILE COMMAND
  fswatch -o $FILE | xargs -n1 -I{} /bin/sh -c "echo -n Rerunning '$COMMAND'...; $COMMAND; echo done."
end
