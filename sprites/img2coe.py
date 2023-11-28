# import os
# from PIL import Image
# import sys

# def img2coe(ImageName: str, compress_rate: None):
#     """
# 		This converts the given image into a Xilinx Coefficients (.coe) file.
# 		Pass it the name of the image including the file suffix.
# 		The file must reside in the directory from which this function is called
# 		or provide the absolute path. 
# 	"""
# 	# Open image
#     img = Image.open(ImageName)
# 	# Verify that the image is in the 'RGB' mode, every pixel is described by 
# 	# three bytes
#     if img.mode != 'RGB':
#         img = img.convert('RGB')

#     # Store Width and height of image
#     width 	= img.size[0]
#     height	= img.size[1]
#     if compress_rate is not None:
#         img = img_compress(img, compress_rate)
#         compressed_width = img.size[0]
#         compressed_height = img.size[1]

#     # Create a .coe file and open it.
#     # Write the header to the file, where lines that start with ';' 
#     # are commented
#     filetype = ImageName[ImageName.find('.'):]
#     filename = ImageName.replace(filetype,'.coe')
#     imgcoe = open(filename, 'w')
#     imgcoe.write(';image_rows{}\n'.format(compressed_width))
#     imgcoe.write(';image_columns{}\n'.format(compressed_height))
#     # imgcoe.write(';compressed_image_row{}\n'.format(compressed_width))
#     # imgcoe.write(';compressed_image_columns{}\n'.format(compressed_height))
#     # imgcoe.write(';sizex{}\n'.format(15))
#     # imgcoe.write(';sizey{}\n'.format(20))
#     imgcoe.write(';total_memory_rows{}\n'.format(compressed_width*compressed_height))
#     imgcoe.write('memory_initialization_radix = 16;\n')
#     imgcoe.write('memory_initialization_vector =\n')

#     # Iterate through every pixel, retain the 3 least significant bits for the
#     # red and green bytes and the 2 least significant bits for the blue byte. 
#     # These are then combined into one byte and their hex equivalent is written
#     # to the .coe file
#     cnt = 0
#     line_cnt = 0
#     for r in range(0, compressed_height):
#         for c in range(0, compressed_width):
#             cnt += 1
#             # Check for IndexError, usually occurs if the script is trying to 
#             # access an element that does not exist
#             try:
#                 R,G,B = img.getpixel((c,r))
#             except IndexError:
#                 print('Index Error Occurred At:')
#                 print('c: {}, r:{}'.format(c,r))
#                 sys.exit()
#             # convert the value (0-255) to a binary string by cutting off the 
#             # '0b' part and left filling zeros until the string represents 8 bits
#             # then slice off the bits of interest with [5:] for red and green
#             # or [6:] for blue
#             Rb = bin(R)[2:].zfill(8)[:4]
#             Gb = bin(G)[2:].zfill(8)[:4]
#             Bb = bin(B)[2:].zfill(8)[:4]
            
#             Outbyte = Rb+Gb+Bb
#             # Check for Value Error, happened when the case of the pixel being 
#             # zero was not handled properly	
#             try:
#                 target_str = '%2.2X'%int(Outbyte,2)
#                 if len(target_str) != 3:
#                     target_str = '0'+target_str
#                 imgcoe.write(target_str)
#             except ValueError:
#                 print('Value Error Occurred At:')
#                 print('R:{0} G:{1} B{2}'.format(R,G,B))
#                 print('Rh:{0} Gh:{1} Bh:{2}'.format(hex(Rb), hex(Gb), hex(Bb)))
#                 sys.exit()
#             # Write correct punctuation depending on line end, byte end,
#             # or file end
#             if c==compressed_width-1 and r==compressed_height-1:
#                 imgcoe.write(';')
#             else:
#                 if cnt%1 == 0:
#                     imgcoe.write(',\n')
#                     line_cnt+=1
#                 else:
#                     imgcoe.write(',')
#     imgcoe.close()
#     print('Xilinx Coefficients File:{} DONE'.format(filename))
#     print('Converted from {} to .coe'.format(filetype))
#     print('Size: h:{} pixels w:{} pixels'.format(compressed_height, compressed_width))
#     print('COE file is 32 bits wide and {} bits deep'.format(line_cnt))
#     print('Total addresses: {}'.format(32*(line_cnt+1)))


# def img_compress(img, compress_rate: float = 0.2):
#     # Store Width and height of image
#     width 	= img.size[0]
#     height	= img.size[1]
#     compress_width = int(width * compress_rate)
#     compress_height = int(height * compress_rate)
#     return img.resize((compress_width, compress_height))


# if __name__ == '__main__':
#     img2coe('palm.jpeg', 1.0)



from PIL import Image

def img2coe(image_path, coe_file_path, width=None, height=None, compress_rate: float = None):
    # Open the image
    img = Image.open(image_path)
    if img.mode != 'RGB':
        img = img.convert('RGB')

    # Resize the image if width and height are provided
    if width and height:
        img = img.resize((width, height))
    if compress_rate is not None:
        img = img_compress(img, compress_rate)

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

def img_compress(img, compress_rate: float = 1.0):
    # Store Width and height of image
    width 	= img.size[0]
    height	= img.size[1]
    compress_width = int(width * compress_rate)
    compress_height = int(height * compress_rate)
    return img.resize((compress_width, compress_height))

# Example usage
if __name__ == '__main__':
    img2coe('background.jpeg', 'background.coe', compress_rate=0.5)
