starship init fish | source

if status is-interactive
    # Commands to run in interactive sessions can go here
end

function nvm
   bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

set -x NVM_DIR ~/.nvm
nvm use default --silent

source /opt/homebrew/opt/asdf/libexec/asdf.fish
source (pack completion --shell fish)



alias vim "nvim"
