function nvm
    bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

fish_add_path /opt/homebrew/bin
fish_add_path /usr/local/bin
fish_add_path /Users/$USER/Library/Python/3.9/bin
fish_add_path /Users/$USER/Library/Python/3.10/bin
fish_add_path /Users/$USER/.cargo/bin
fish_add_path /Users/$USER/.asdf/shims
fish_add_path /Users/$USER/.local/bin
fish_add_path /home/leonardovee/.npm/bin

set -x EDITOR nvim
set -x VISUAL $EDITOR
set -U fish_greeting 

#source /Users/$USER/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
#source /Users/$USER/.config/fish/completions/asdf.fish

fzf --fish | source

source /Users/$USER/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
source /Users/$USER/.config/fish/completions/asdf.fish

# uv
fish_add_path "/Users/vieira.leonardo/.local/bin"
