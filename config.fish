starship init fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here
end

function nvm
   bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

set -x NVM_DIR ~/.nvm
nvm use default --silent

if type nvim -sq
  alias vim "nvim"
  alias nv "nvim"
end

if type bat -sq
  alias cat "bat --paging=never --theme=gruvbox-dark --tabs=2"
end

function wr -a FILE COMMAND
  fswatch -o $FILE | xargs -n1 -I{} /bin/sh -c "echo -n Rerunning '$COMMAND'...; $COMMAND; echo done."
end
