import sys
from PIL import Image

def img2coe(image_path, coe_file_path, width=None, height=None):
    # Open the image
    img = Image.open(image_path)
    if img.mode != 'RGB':
        img = img.convert('RGB')

    # Get the image size
    width, height = img.size

    # Create a .coe file and write the header
    with open(coe_file_path, 'w') as imgcoe:
        imgcoe.write(';image_rows{}\n'.format(height))
        imgcoe.write(';image_columns{}\n'.format(width))
        imgcoe.write(';total_memory_rows{}\n'.format(width*height))
        imgcoe.write('memory_initialization_radix=16;\n')
        imgcoe.write('memory_initialization_vector=\n')

        # Iterate over the pixels
        line_cnt = 0
        cnt = 0
        for y in range(height):
            for x in range(width):
                cnt += 1
                # Get the RGB values
                R, G, B = img.getpixel((x, y))
                # Convert to 4 bits per channel
                Rb = R >> 4
                Gb = G >> 4
                Bb = B >> 4
                # Combine into a 12-bit value
                pixel_val = (Rb << 8) | (Gb << 4) | Bb
                # Write the hex value to the .coe file
                imgcoe.write('{:03X}'.format(pixel_val))
                if x == width - 1 and y == height - 1:
                    imgcoe.write(';')
                else:
                    if cnt%1 == 0:
                        imgcoe.write(',\n')
                        line_cnt+=1
                    else:
                        imgcoe.write(',')
    print('COE file generated at: {}'.format(coe_file_path))


if __name__ == '__main__':
    print("Usage:\n {} <path_to_image> <out_filename>.coe".format(sys.argv[0]))
    print("Or\n {}".format(sys.argv[0]))
    args_len = len(sys.argv)
    if (args_len == 3):
        img2coe(sys.argv[1], sys.argv[2])
    else:
        img2coe('res_bullet.png', 'bullet.coe')
        img2coe('res_cannon.png', 'cannon.coe')
        img2coe('res_enemy1.jpeg', 'enemy1.coe')
        