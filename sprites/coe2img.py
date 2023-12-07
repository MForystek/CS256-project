from PIL import Image

def coe2img(coe_file_path, output_image_path, sprite_width, sprite_height):
    """
    Convert a .coe file back into an image based on sprite dimensions.
    
    Args:
    coe_file_path: The file path for the .coe file.
    output_image_path: The file path for the output image.
    sprite_width: The width of the sprite.
    sprite_height: The height of the sprite.
    """
    # Read the .coe file and extract the hex values after the header
    with open(coe_file_path, 'r') as coe_file:
        coe_content = coe_file.read()
        hex_values = coe_content.split('memory_initialization_vector=')[1]
        hex_values = hex_values.replace(';', '').replace(',', '').split()

    # Create a new image in RGB mode
    img = Image.new('RGB', (sprite_width, sprite_height))
    pixels = img.load()

    # Iterate over the rows and columns of the sprite
    for y in range(sprite_height):
        for x in range(sprite_width):
            # Calculate the address in the COE file
            address = y * sprite_width + x
            # Get the hex value for the current pixel data
            hex_value = hex_values[address]
            # Convert the hex value to RGB values (expanded to 8 bits)
            R = (int(hex_value[0], 16) << 4)
            G = (int(hex_value[1], 16) << 4)
            B = (int(hex_value[2], 16) << 4)
            # Set the pixel in the image
            pixels[x, y] = (R, G, B)

    # Save the image
    img.save(output_image_path)

if __name__ == '__main__':
    coe_file_path = 'cannon.coe'
    output_image_path = 'coe_cannon.png'
    sprite_width = 92  # Update with the actual width of the sprite
    sprite_height = 65  # Update with the actual height of the sprite
    coe2img(coe_file_path, output_image_path, sprite_width, sprite_height)