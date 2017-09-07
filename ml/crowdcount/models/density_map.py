import cv2
from PIL import Image
import numpy as np


_gaussian_kernel = 35


def generate(image_path, annotations):
    with Image.open(image_path) as img:
        width, height = img.size

    pixels = np.zeros((height, width))
    _sum_heads(pixels, annotations)
    return cv2.GaussianBlur(pixels, (_gaussian_kernel, _gaussian_kernel), 0)


def _sum_heads(pixels, annotations):
    for a in annotations:
        pixels[int(a[1]), int(a[0])] += 1
