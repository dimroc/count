from PIL import Image
import numpy as np


def generate(image_path, annotations):
    with Image.open(image_path) as img:
        width, height = img.size

    pixels = np.zeros((height, width, 3))
    _plot_deltas(pixels, annotations)
    _gaussian_blur(pixels)
    return Image.fromarray(pixels.astype('uint8'), 'RGB')


def _plot_deltas(pixels, annotations):
    pass


def _gaussian_blur(pixels):
    pass
