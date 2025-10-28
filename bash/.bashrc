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

Automatically drop into fish for interactive shells when available.
if [[ "$-" == *i* && -z "${BASH_EXECUTION_STRING:-}" ]]; then
    WHICH_FISH="$(command -v fish 2>/dev/null)"
    if [[ -n "$WHICH_FISH" && -x "$WHICH_FISH" ]] && ! "$SHELL" -ef "$WHICH_FISH"; then
        FISH_CHECK_LOG="$(mktemp -t fish-check.XXXXXX)"
        if "$WHICH_FISH" -c 'exit' >/dev/null 2>"$FISH_CHECK_LOG"; then
            rm -f "$FISH_CHECK_LOG"
            exec env SHELL="$WHICH_FISH" "$WHICH_FISH" -i
        else
            if [[ -s "$FISH_CHECK_LOG" ]]; then
                echo "WARN: fish startup failed; staying in bash." >&2
            else
                echo "WARN: fish detected but failed health check; staying in bash." >&2
            fi
            rm -f "$FISH_CHECK_LOG"
        fi
    fi
fi
