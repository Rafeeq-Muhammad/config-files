
if status is-interactive

    if type -q nvm
        if not nvm use --silent 20 >/dev/null 2>&1
            echo "Installing Node.js 20 via nvm..."
            nvm install 20
            nvm use --silent 20 >/dev/null 2>&1
        end
    end

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
alias geminiflash="gemini --model gemini-2.5-flash"

# Navigation Aliases
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."

function run
    if test (count $argv) -eq 0
        echo "Usage: run <file.(cpp|c|py)> [args...]"
        return 1
    end

    set -l filepath $argv[1]
    set -l args $argv[2..-1]
    set -l ext (string lower (string match -r '\.[^.]+$' -- $filepath))

    if test -z "$ext"
        echo "run: unsupported file type for $filepath"
        return 1
    end

    switch $ext
    case ".cpp"
        set -l filename (basename $filepath .cpp)
        g++ -fsanitize=address -o $filename $filepath
        if test $status -ne 0
            echo "Compilation failed!"
            return 1
        end
        ./$filename $args
        set -l exit_code $status
        rm -f $filename
        return $exit_code
    case ".c"
        set -l filename (basename $filepath .c)
        gcc -fsanitize=address -o $filename $filepath
        if test $status -ne 0
            echo "Compilation failed!"
            return 1
        end
        ./$filename $args
        set -l exit_code $status
        rm -f $filename
        return $exit_code
    case ".py"
        python3 $filepath $args
        return $status
    case '*'
        echo "run: unsupported file type $ext"
        return 1
    end
end

function build
    # Check if a filename was provided
    if test (count $argv) -eq 0
        echo "Usage: run_cpp <file.cpp>"
        return 1
    end

    set -l filepath $argv[1]
    set -l ext (string lower (string match -r '\.[^.]+$' -- $filepath))

    switch $ext
    case ".cpp"
        set -l filename (basename $filepath .cpp)
        g++ -fsanitize=address -g -o $filename $filepath
        if test $status -ne 0
            echo "Compilation failed!"
            return 1
        end
    case ".c"
        set -l filename (basename $filepath .c)
        gcc -fsanitize=address -g -o $filename $filepath
        if test $status -ne 0
            echo "Compilation failed!"
            return 1
        end
    case '*'
        echo "build: unsupported file type $ext"
        return 1
    end

end

# Created by `pipx` on 2025-10-19 22:56:09
set PATH $PATH /home/rafeeq/.local/bin
