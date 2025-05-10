fish_add_path /opt/homebrew/bin
fish_add_path /usr/local/bin
fish_add_path /home/$USER/Library/Python/3.9/bin
fish_add_path /home/$USER/Library/Python/3.10/bin
fish_add_path /home/$USER/.cargo/bin
fish_add_path /home/$USER/.asdf/shims

set -x EDITOR nvim
set -x VISUAL $EDITOR
set -U fish_greeting 

source /Users/$USER/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

source /home/leonardovee/.config/fish/completions/asdf.fish
