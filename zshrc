# zsh config shortcut
alias zshconfig="code ~/.zshrc"

# Git aliases
alias gl="glog --pretty='%C(auto)%h%Creset%C(auto)%d%Creset %s %C(cyan)(%cr) %C(bold blue)<%an>%Creset'"
alias glg="gl --all"
alias gfo="git fetch origin -Pp"
alias gshst="git show --stat"
alias gg="git gui"

# Replace cat with bat
alias cat="bat --paging=never --style=plain"
alias catt="bat --paging=never"

# Utils
alias fixusbd="sudo launchctl stop com.apple.usbd; sudo launchctl start com.apple.usbd"
alias gatekeeper_bypass="sudo xattr -rd com.apple.quarantine"
alias mp3="youtube-dl -o \"%(title)s-%(id)s.%(ext)s\" -x --audio-format mp3 --embed-thumbnail"
alias aac="youtube-dl -o \"%(title)s-%(id)s.%(ext)s\" -x --audio-format aac --embed-thumbnail"
alias notify="osascript -e 'display notification \"Task Done\" with title \"Shell\" sound name \"Glass\"'"
