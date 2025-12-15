function nvm
    bass source ~/.nvm/nvm.sh --no-use ';' nvm $argv
end

fish_add_path /usr/local/bin
fish_add_path /usr/local/go/bin/
fish_add_path /opt/homebrew/bin

fish_add_path ~/go/bin/
fish_add_path ~/.cargo/bin
fish_add_path ~/.npm/bin
fish_add_path ~/.asdf/shims
fish_add_path ~/.local/bin
fish_add_path ~/Library/Python/3.9/bin
fish_add_path ~/Library/Python/3.10/bin

set -x EDITOR nvim
set -x VISUAL $EDITOR
set -U fish_greeting

source ~/Vulkan/1.4.328.1/setup-env.sh
