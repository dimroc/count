import cv2
from PIL import Image
import numpy as np


_gaussian_kernel = 35
_scale_for_fcn = 1 / 4  # Hardcoded to match final dimensions of FCN


def generate(image_path, annotations):
    with Image.open(image_path) as img:
        downscaled_size = (np.asarray(img.size) * _scale_for_fcn).astype(int)

    pixels = np.zeros(downscaled_size[::-1])  # np takes rows then cols, so height then w.
    _sum_heads(pixels, annotations)
    return cv2.GaussianBlur(pixels, (_gaussian_kernel, _gaussian_kernel), 0)


def generate_3d(image_path, annotations):
    """
    Add axis at the end to be compatible w keras.
    e.g. [640, 480] becomes [640, 480, 1]
    """
    return generate(image_path, annotations)[..., None]


def _sum_heads(pixels, annotations):
    for a in annotations:
        pixels[int(a[1] * _scale_for_fcn), int(a[0] * _scale_for_fcn)] += 1
