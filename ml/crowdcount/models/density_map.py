from PIL import Image
import cv2
import numpy as np
import crowdcount.models.annotations as ants
import crowdcount.models.paths as ccp


_gaussian_kernel = 15
_scale_for_fcn = 1 / 4  # Hardcoded to match final dimensions of FCN


def generate(image_path, annotations):
    with Image.open(image_path) as img:
        downscaled_size = (np.asarray(img.size) * _scale_for_fcn).astype(int)

    pixels = np.zeros(downscaled_size[::-1])  # np takes rows then cols, so height then w.
    _sum_heads(pixels, annotations, image_path)
    return cv2.GaussianBlur(pixels, (_gaussian_kernel, _gaussian_kernel), 0)


def generate_3d(image_path, annotations):
    """
    Add axis at the end to be compatible w keras.
    e.g. [640, 480] becomes [640, 480, 1]
    """
    return generate(image_path, annotations)[..., None]


def generate_truth_batch(path):
    """
    From an image path, generate the density map based on the ground truth
    as a batch of 1, ready for ml consumption.
    """
    return generate(ccp.datapath(path), ants.groundtruth.get(path))[np.newaxis]


def _sum_heads(pixels, annotations, path):
    for a in annotations:
        x, y = int(a[0] * _scale_for_fcn), int(a[1] * _scale_for_fcn)
        if y >= pixels.shape[0] or x >= pixels.shape[1]:
            print("{},{} is out of range, skipping annotation for {}".format(x, y, path))
        else:
            pixels[y, x] += 1
