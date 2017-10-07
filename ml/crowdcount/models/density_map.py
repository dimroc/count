from PIL import Image
import crowdcount.models.annotations as ants
import crowdcount.models.mask as mask
import crowdcount.models.paths as ccp
import cv2
import numpy as np

_gaussian_kernel = 15
_scale_for_fcn = 1 / 4  # Hardcoded to match final dimensions of FCN


def generate(image_key, annotations):
    with Image.open(ccp.datapath(image_key)) as img:
        downscaled_size = (np.asarray(img.size) * _scale_for_fcn).astype(int)

    pixels = np.zeros(downscaled_size[::-1])  # np takes rows then cols, so height then w.
    _sum_heads(pixels, annotations, image_key)
    return cv2.GaussianBlur(pixels, (_gaussian_kernel, _gaussian_kernel), 0)


def generate_3d(image_key, annotations):
    """
    Add axis at the end to be compatible w keras.
    e.g. [640, 480] becomes [640, 480, 1]
    """
    return generate(image_key, annotations)[..., None]


def generate_truth_batch(image_key, usemask=False):
    """
    From an image image_key, generate the density map based on the ground truth
    as a batch of 1, ready for ml consumption.
    """
    return generate_truth(image_key)[np.newaxis][..., None]


def generate_truth(image_key, usemask=False):
    truth = generate(image_key, ants.groundtruth.get(image_key))
    if usemask:
        return (truth * mask.array)
    else:
        return truth


def _sum_heads(pixels, annotations, image_key):
    """
    Annotations are x, y.
    Numpy pixels are y, x.
    """
    for a in annotations:
        x, y = int(a[0] * _scale_for_fcn), int(a[1] * _scale_for_fcn)
        if y >= pixels.shape[0] or x >= pixels.shape[1]:
            print("{},{} is out of range, skipping annotation for {}".format(x, y, image_key))
        else:
            pixels[y, x] += 1
