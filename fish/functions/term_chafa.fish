function term_chafa --description "Render higher detail Unicode art sized to the terminal"
    if not command -q chafa
        echo "term_chafa: chafa is not installed; try 'sudo apt install chafa'" >&2
        return 1
    end

    if test (count $argv) -lt 1
        echo "Usage: term_chafa <image> [percent_width] [percent_height]" >&2
        return 1
    end

    set -l img $argv[1]
    set -l pw 33
    set -l ph 0

    if test (count $argv) -ge 2
        set pw $argv[2]
    end
    if test (count $argv) -ge 3
        set ph $argv[3]
    end

    if not string match -qr '^[0-9]+$' -- $pw
        set pw 33
    end
    if not string match -qr '^[0-9]+$' -- $ph
        set ph 0
    end

    set -l cols (tput cols 2>/dev/null)
    set -l rows (tput lines 2>/dev/null)

    if not string match -qr '^[0-9]+$' -- $cols
        set cols 80
    end
    if not string match -qr '^[0-9]+$' -- $rows
        set rows 24
    end

    set -l w (math --scale=0 "$cols * $pw / 100")

    if test -z "$w"
        set w $cols
    end

    if test $w -lt 1
        set w 1
    end
    if test $w -gt $cols
        set w $cols
    end

    set -l h ""
    if test $ph -gt 0
        set h (math --scale=0 "$rows * $ph / 100")
    end
    if test -n "$h"
        if test $h -lt 1
            set h 1
        end
        if test $h -gt $rows
            set h $rows
        end
        chafa --size "$w"x"$h" --symbols block --animate off "$img"
    else
        chafa --size "$w"x --symbols block --animate off "$img"
    end
end
