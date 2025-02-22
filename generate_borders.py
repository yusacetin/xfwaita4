from PIL import Image
import os

DARK = 0
LIGHT = 1

ACTIVE = 0
INACTIVE = 1

DARK_ACTIVE_BORDER = (62, 62, 62, 255)
DARK_INACTIVE_BORDER = DARK_ACTIVE_BORDER
DARK_ACTIVE_PADDING = (53, 53, 53, 255)
DARK_INACTIVE_PADDING = DARK_ACTIVE_PADDING
DARK_BORDER_WIDTH = 5

LIGHT_ACTIVE_BORDER = (255, 255, 255, 255)
LIGHT_INACTIVE_BORDER = LIGHT_ACTIVE_BORDER
LIGHT_ACTIVE_PADDING = (246, 245, 244, 255)
LIGHT_INACTIVE_PADDING = LIGHT_ACTIVE_PADDING
LIGHT_BORDER_WIDTH = 5

CORNER_SPAN = 16

def main():
    generate_and_save(DARK)
    generate_and_save(LIGHT)

def generate_and_save(variant):
    # Generate
    active_bottom = generate_bottom(variant, ACTIVE)
    inactive_bottom = generate_bottom(variant, INACTIVE)

    active_bottom_right = generate_bottom_right(variant, ACTIVE)
    inactive_bottom_right = generate_bottom_right(variant, INACTIVE)

    active_bottom_left = flip_horizontally(active_bottom_right)
    inactive_bottom_left = flip_horizontally(inactive_bottom_right)

    active_right = generate_right(variant, ACTIVE)
    inactive_right = generate_right(variant, INACTIVE)

    active_left = flip_horizontally(active_right)
    inactive_left = flip_horizontally(inactive_right)

    # Save
    dest = "gen/"
    os.makedirs(dest, exist_ok=True)

    variant_str = "dark"
    if (variant == LIGHT): variant_str = "light"
    
    save_image(active_bottom, dest + variant_str + "_active_bottom.png")
    save_image(inactive_bottom, dest + variant_str + "_inactive_bottom.png")

    save_image(active_right, dest + variant_str + "_active_right.png")
    save_image(inactive_right, dest + variant_str + "_inactive_right.png")

    save_image(active_left, dest + variant_str + "_active_left.png")
    save_image(inactive_left, dest + variant_str + "_inactive_left.png")

    save_image(active_bottom_right, dest + variant_str + "_active_bottom_right.png")
    save_image(inactive_bottom_right, dest + variant_str + "_inactive_bottom_right.png")

    save_image(active_bottom_left, dest + variant_str + "_active_bottom_left.png")
    save_image(inactive_bottom_left, dest + variant_str + "_inactive_bottom_left.png")

def save_image(pixels, fpath):
    rows = len(pixels)
    cols = len(pixels[0])
    image = Image.new("RGBA", (cols, rows))
    image_pixels = image.load()
    for row in range(rows):
        for col in range(cols):
            image_pixels[col, row] = pixels[row][col]
    image.save(fpath, "PNG")

def generate_bottom(variant, mode):
    width = DARK_BORDER_WIDTH if (variant == DARK) else LIGHT_BORDER_WIDTH
    pixels = []
    if (variant == DARK):
        if (mode == ACTIVE):
            pixels = [[DARK_ACTIVE_PADDING] for row in range(width-1)]
            pixels.append([DARK_ACTIVE_BORDER])
        else: # inactive
            pixels = [[DARK_INACTIVE_PADDING] for row in range(width-1)]
            pixels.append([DARK_INACTIVE_BORDER])
    else: # light
        if (mode == ACTIVE):
            pixels = [[LIGHT_ACTIVE_PADDING] for row in range(width-1)]
            pixels.append([LIGHT_ACTIVE_BORDER])
        else: # inactive
            pixels = [[LIGHT_INACTIVE_PADDING]  for row in range(width-1)]
            pixels.append([LIGHT_INACTIVE_BORDER])
    return pixels

def generate_bottom_right(variant, mode):
    width = DARK_BORDER_WIDTH if (variant == DARK) else LIGHT_BORDER_WIDTH
    
    if (variant == DARK):
        if (mode == ACTIVE):
            border = DARK_ACTIVE_BORDER
            padding = DARK_ACTIVE_PADDING
        else: # inactive
            border = DARK_INACTIVE_BORDER
            padding = DARK_INACTIVE_PADDING
    else: # light
        if (mode == ACTIVE):
            border = LIGHT_ACTIVE_BORDER
            padding = LIGHT_ACTIVE_PADDING
        else: # inactive
            border = LIGHT_INACTIVE_BORDER
            padding = LIGHT_INACTIVE_PADDING

    pixels = [[(0,0,0,0) for col in range(CORNER_SPAN)] for row in range(CORNER_SPAN)]
    for row in range(CORNER_SPAN):
        for col in range(CORNER_SPAN):
            if (col == CORNER_SPAN-1):
                pixels[row][col] = border
            elif (row == (CORNER_SPAN-1)):
                pixels[row][col] = border
            elif (col > (CORNER_SPAN-DARK_BORDER_WIDTH-1)):
                pixels[row][col] = padding
            elif (row > (CORNER_SPAN-DARK_BORDER_WIDTH-1)):
                pixels[row][col] = padding
            else:
                pass # leave at transparent
    return pixels

def generate_right(variant, mode):
    width = DARK_BORDER_WIDTH if (variant == DARK) else LIGHT_BORDER_WIDTH
    pixels = []
    if (variant == DARK):
        if (mode == ACTIVE):
            pixels = [[DARK_ACTIVE_PADDING for row in range(width-1)]]
            pixels[0].append(DARK_ACTIVE_BORDER)
        else: # inactive
            pixels = [[DARK_INACTIVE_PADDING for row in range(width-1)]]
            pixels[0].append(DARK_INACTIVE_BORDER)
    else: # light
        if (mode == ACTIVE):
            pixels = [[LIGHT_ACTIVE_PADDING for row in range(width-1)]]
            pixels[0].append(LIGHT_ACTIVE_BORDER)
        else: # inactive
            pixels = [[LIGHT_INACTIVE_PADDING for row in range(width-1)]]
            pixels[0].append(LIGHT_INACTIVE_BORDER)
    return pixels

def flip_horizontally(original_array):
    rows = len(original_array)
    cols = len(original_array[0])
    pixels = [[(0,0,0,0) for col in range(cols)] for row in range(rows)]
    for row in range(rows):
        for col in range(cols):
            pixels[row][col] = original_array[row][cols - col - 1]
    return pixels

if __name__ == "__main__":
    main()
