# ~/.bashrc: executed by bash(1) for non-login shells.
# see /usr/share/doc/bash/examples/startup-files (in the package bash-doc)
# for examples

# Aliases
alias what="pwd && ls"
alias configbash="vim ~/.bashrc"
alias sourcebash="source ~/.bashrc"

# Navigation Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

# Alias definitions.
# You may want to put all your additions into a separate file like
# ~/.bash_aliases, instead of adding them here directly.
# See /usr/share/doc/bash-doc/examples in the bash-doc package.

if [ -f ~/.bash_aliases ]; then
    . ~/.bash_aliases
fi

# Automatically drop into fish for interactive shells when available.
if [[ "$-" == *i* ]]; then
    WHICH_FISH="$(command -v fish 2>/dev/null)"
    if [[ -n "$WHICH_FISH" && -x "$WHICH_FISH" ]] && ! "$SHELL" -ef "$WHICH_FISH"; then
        exec env SHELL="$WHICH_FISH" "$WHICH_FISH" -i
    fi
fi
