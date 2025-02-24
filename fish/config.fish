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

function replace_brackets
    # Join all arguments into a single string
    set input (string join " " $argv)

    # Replace [ with { and ] with }
    set output (string replace -a "[" "{" -- $input)
    set output (string replace -a "]" "}" -- $output)

    # Print the result
    echo $output
end

