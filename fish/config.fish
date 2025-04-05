
if status is-interactive

    # Automaticall start tmux session if not already in one
    if not set -q TMUX
        tmux attach-session -t default || tmux new-session -s default
    end

    if set -q TMUX
        # dark/light soft/medium/hard
        theme_gruvbox dark soft
    end

end


# Aliases
alias what="pwd && ls"
alias configfish="nvim ~/.config/fish/config.fish"
alias sourcefish="exec fish"
alias catfish="cat ~/.config/fish/config.fish"
alias confignvim="cd ~/.config/kickstart.nvim/ && nvim"

# Programs
alias anki="flatpak run net.ankiweb.Anki >/dev/null 2>&1 & disown"

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

function run
    # Check if a filename was provided
    if test (count $argv) -eq 0
        echo "Usage: run_cpp <file.cpp>"
        return 1
    end

    # Get the filename without extension
    set filename (basename $argv[1] .cpp)

    # Compile the C++ file with g++
    g++ -o $filename $argv[1]

    # Check if compilation was successful
    if test $status -ne 0
        echo "Compilation failed!"
        return 1
    end

    # Run the executable
    ./$filename

    # Remove the executable after execution
    rm -f $filename
end

function build
    # Check if a filename was provided
    if test (count $argv) -eq 0
        echo "Usage: run_cpp <file.cpp>"
        return 1
    end

    # Get the filename without extension
    set filename (basename $argv[1] .cpp)

    # Compile the C++ file with g++
    g++ -g -o $filename $argv[1]

    # Check if compilation was successful
    if test $status -ne 0
        echo "Compilation failed!"
        return 1
    end

end

