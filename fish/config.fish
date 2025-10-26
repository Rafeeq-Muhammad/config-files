
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
alias geminiflash="gemini --model gemini-2.5-flash"

# Programs
alias anki="flatpak run net.ankiweb.Anki >/dev/null 2>&1 & disown"

  function next_leetcode
      set -l venv_activate /home/rafeeq/workspace/next-leetcode/.venv/bin/activate.fish
      if not test -f $venv_activate
          echo "virtualenv missing at $venv_activate" >&2
          return 1
      end

      source $venv_activate
      python /home/rafeeq/workspace/next-leetcode/next-leetcode.py $argv
      set -l exit_code $status

      if functions -q deactivate
          deactivate
      end

      return $exit_code
  end

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
    g++ -fsanitize=address -o $filename $argv[1]

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
    g++ -fsanitize=address -g -o $filename $argv[1]

    # Check if compilation was successful
    if test $status -ne 0
        echo "Compilation failed!"
        return 1
    end

end

function concat_videos --description "Concat numbered video files in the current dir"
    argparse 'o/output=' 'e/extension=' -- $argv
    or return 1

    set -l output (set -q _flag_output; and echo $_flag_output; or echo merged.mp4)
    set -l ext (set -q _flag_extension; and echo $_flag_extension)

    set -l files
    set -l search_order mp4 mkv mov m4v avi

    if test -n "$ext"
        set files (command find . -maxdepth 1 -type f -iname "*.$ext" -printf "%f\n" | sort -V)
    else
        for candidate in $search_order
            set files (command find . -maxdepth 1 -type f -iname "*.$candidate" -printf "%f\n" | sort -V)
            if test (count $files) -gt 0
                set ext $candidate
                break
            end
        end
    end

    if test (count $files) -eq 0
        if test -n "$ext"
            echo "concat_videos: no *.$ext files found in "(pwd) >&2
        else
            echo "concat_videos: no video files found in "(pwd)" (tried: $search_order)" >&2
        end
        return 1
    end

    set -l listfile (mktemp)
    for f in $files
        set -l abs_path (realpath "$f")
        printf "file '%s'\n" "$abs_path" >> $listfile
    end

    ffmpeg -f concat -safe 0 -i "$listfile" -c copy "$output"
    set -l exit_code $status
    command rm -f "$listfile"
    return $exit_code
end


# Created by `pipx` on 2025-10-19 22:56:09
set PATH $PATH /home/rafeeq/.local/bin
