# Custom Server Aliases
alias cortanna='ssh cortanna'
alias cortana='ssh cortana'

# Plugin update aliases
alias update-plugins='omarchy plugin update --yes'
alias plugin-update='omarchy plugin update --yes'

# LM Studio CLI (if installed)
[[ -d "$HOME/.lmstudio/bin" ]] && export PATH="$PATH:$HOME/.lmstudio/bin"
