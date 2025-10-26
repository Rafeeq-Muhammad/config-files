
function show_random_picture
    set img_dir "$HOME/.config/fish/images"
    
    # Use 'find' to list images and store them in an array
    set images (find $img_dir -type f \( -iname "*.jpg" -o -iname "*.png" -o -iname "*.jpeg" \) 2>/dev/null)
    
    if test (count $images) -gt 0
        # Pick a random image using a random index
        set random_index (random 1 (count $images))
        set random_image $images[$random_index]

        # Display image as ASCII
        jp2a --colors --width=(math (tput cols) / 3) $random_image
    else
        # Fallback to neofetch if no images are found
        neofetch
    end
end

# Call the function
show_random_picture

# neofetch
