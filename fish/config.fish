function nvm
  bass source ~/.nvm/nvm.sh ';' nvm $argv
end

function cat
  bat --style=plain --theme=gruvbox-light $argv
end

fish_add_path /opt/homebrew/bin
fish_add_path /Users/$USER/go/bin
fish_add_path /Users/$USER/.cargo/bin
fish_add_path /Users/$USER/Library/Python/3.9/bin
fish_add_path /usr/local/go/bin
fish_add_path /usr/local/lua-language-server/bin
fish_add_path /home/leonardovee/go/bin
fish_add_path /home/leonardovee/.local/bin

# opam configuration
source /home/leonardovee/.opam/opam-init/init.fish > /dev/null 2> /dev/null; or true

# alias
alias k="sudo kubectl"
alias kind="sudo kind"
