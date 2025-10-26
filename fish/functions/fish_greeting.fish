
function show_random_picture
    set -l img_dir "$HOME/.config/fish/images"

    set -l images (find $img_dir -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) 2>/dev/null)

    if test (count $images) -gt 0
        set -l random_index (random 1 (count $images))
        set -l random_image $images[$random_index]

        if command -q chafa
            term_chafa "$random_image" 33
        else if command -q neofetch
            neofetch
        end
    else if command -q neofetch
        neofetch
    end
end

show_random_picture
