function nvm
  bass source ~/.nvm/nvm.sh ';' nvm $argv
end

function cat
  bat --style=plain $argv
end

fish_add_path /opt/homebrew/bin
fish_add_path /Users/$USER/go/bin
fish_add_path /Users/$USER/.cargo/bin
fish_add_path /Users/$USER/Library/Python/3.9/bin

