function concat_videos --description "Concat numbered video files in the current dir"
    argparse 'o/output=' 'e/extension=' -- $argv
    or return 1

    set -l output (set -q _flag_output; and echo $_flag_output; or echo merged.mp4)
    set -l ext (set -q _flag_extension; and echo $_flag_extension)

    set -l files
    set -l search_order mp4 mkv mov m4v avi

    if test -n "$ext"
        set files (command find . -maxdepth 1 -type f -iname "*.$ext" -printf "%f\n" | sort)
    else
        for candidate in $search_order
            set files (command find . -maxdepth 1 -type f -iname "*.$candidate" -printf "%f\n" | sort)
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
