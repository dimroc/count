import cv2
from PIL import Image
import numpy as np


_gaussian_kernel = 35
_scale_for_fcn = 1 / 4.5859872611  # Hardcoded to match final dimensions of FCN


def generate(image_path, annotations):
    with Image.open(image_path) as img:
        width, height = img.size

    pixels = np.zeros((height, width))
    _sum_heads(pixels, annotations)
    return cv2.GaussianBlur(pixels, (_gaussian_kernel, _gaussian_kernel), 0)


def generate_fcn(image_path, annotations):
    """
    Add axis at the end to be compatible w keras.
    e.g. [640, 480] becomes [640, 480, 1]
    """
    return downsample(generate(image_path, annotations))[..., None]


def downsample(array):
    width, height, *_ = array.shape
    return cv2.resize(array, (round(height * _scale_for_fcn), round(width * _scale_for_fcn)))


def _sum_heads(pixels, annotations):
    for a in annotations:
        pixels[int(a[1]), int(a[0])] += 1
