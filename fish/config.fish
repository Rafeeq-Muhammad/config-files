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

function run_cpp
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

function fish_greeting
    if not command -v neofetch > /dev/null
        echo "Neofetch not found. Installing..."
        sudo apt install -y neofetch
    end
    neofetch
end


