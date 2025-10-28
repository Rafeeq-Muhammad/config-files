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
