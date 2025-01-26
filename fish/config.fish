# Aliases
alias what="pwd && ls"
alias configfish="vim ~/.config/fish/config.fish"
alias sourcefish="source ~/.config/fish/config.fish"

# Navigation Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Force GUIs on WSL to use this as the backend instead of forcing wayland to resolve gui issues
export GDK_BACKEND=x11
