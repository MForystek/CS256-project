# from PIL import Image
# import re

# def coe2img(coe_file_path, image_path):
#     # Read the .coe file content
#     with open(coe_file_path, 'r') as file:
#         content = file.read()

#     # Extract image dimensions and pixel data from the file content
#     height = int(re.search(r";image_rows(\d+)", content).group(1))
#     width = int(re.search(r";image_columns(\d+)", content).group(1))
#     pixel_data = re.findall(r"([0-9A-Fa-f]{3})", content)

#     # Create a new image with the specified dimensions
#     img = Image.new('RGB', (width, height))
#     pixels = img.load()

#     # Iterate over the pixel data
#     index = 0
#     for y in range(height):
#         for x in range(width):
#             if index < len(pixel_data):
#                 # Extract the 12-bit value
#                 pixel_val = int(pixel_data[index], 16)
#                 # Extract 4-bit RGB values
#                 R = (pixel_val >> 8) & 0xF
#                 G = (pixel_val >> 4) & 0xF
#                 B = pixel_val & 0xF
#                 # Scale up to 8-bit values
#                 R, G, B = [channel * 17 for channel in (R, G, B)]  # 17 = 255 / 15
#                 pixels[x, y] = (R, G, B)
#                 index += 1

#     # Save the image
#     img.save(image_path)
#     print('Image file generated at: {}'.format(image_path))

# # Example usage
# if __name__ == '__main__':
#     coe2img('output_image.coe', 'recovered_image.png')  # Replace with actual paths


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
    coe_file_path = 'palm.coe'
    output_image_path = 'output_image.png'
    sprite_width = 88  # Update with the actual width of the sprite
    sprite_height = 108  # Update with the actual height of the sprite
    coe2img(coe_file_path, output_image_path, sprite_width, sprite_height)
