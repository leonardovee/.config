function nvm
  bass source ~/.nvm/nvm.sh ';' nvm $argv
end

fish_add_path /opt/homebrew/bin
fish_add_path /usr/local/bin
fish_add_path /usr/local/go/bin
fish_add_path /Users/$USER/go/bin
fish_add_path /Users/$USER/.cargo/bin
fish_add_path /Users/$USER/Library/Python/3.9/bin
fish_add_path /Users/$USER/Library/Python/3.10/bin

# alias k="sudo kubectl"

# opam configuration
source /Users/leonardovee/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true
