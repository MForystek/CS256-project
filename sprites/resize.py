import sys
from PIL import Image

def resize(image_path, width=None, height=None, compress_rate: float = None):
    # Open the image
    img = Image.open(image_path)
    if img.mode != 'RGB':
        img = img.convert('RGB')

    # Resize the image if width and height are provided
    if width and height:
        img = img.resize((width, height))
    if compress_rate is not None:
        img = img_compress(img, compress_rate)
        img.save('res_'+image_path)
    print("File {} resized by: {}".format(image_path, compress_rate))


def img_compress(img, compress_rate: float = 1.0):
    # Store Width and height of image
    width = img.size[0]
    height = img.size[1]
    compress_width = int(width * compress_rate)
    compress_height = int(height * compress_rate)
    return img.resize((compress_width, compress_height))

# Example usage
if __name__ == '__main__':
    print("Usage:\n {} <path_to_image> <out_filename>.coe <compress_rate (0-1)>".format(sys.argv[0]))
    print("Or\n {}".format(sys.argv[0]))
    args_len = len(sys.argv)
    if (args_len == 4):
        resize(sys.argv[1], sys.argv[2], compress_rate=float(sys.argv[3]))
    else:
        exit(1)
        