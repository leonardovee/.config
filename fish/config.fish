if status is-interactive
    # Commands to run in interactive sessions can go here
end
fish_add_path /opt/homebrew/bin
fish_add_path /Users/leonardovee/.cargo/bin 
fish_add_path /Users/leonardovee/.local/bin
fish_add_path /usr/local/bin 
function nvm
      bass source ~/.nvm/nvm.sh ';' nvm $argv
end
