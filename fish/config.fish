if status is-interactive
    # Commands to run in interactive sessions can go here
end

fish_add_path /opt/homebrew/bin
fish_add_path /Users/$USER/.cargo/bin 
fish_add_path /Users/$USER/.local/bin
fish_add_path /usr/local/bin 
fish_add_path /Users/$USER/go/bin/
fish_add_path /Users/$USER/Library/Python/3.10/bin

function nvm
  bass source ~/.nvm/nvm.sh ';' nvm $argv
end
