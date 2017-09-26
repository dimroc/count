import keras.preprocessing.image as kimg
import numpy as np
import re


__all__ = ["fetch_epoch", "image_to_batch"]


def fetch_epoch(path):
    if path:
        match = re.match(r".*(?:weights\.|epoch)(\d+).*", path)
        if match:
            return int(match.group(1))
        else:
            print("Could not retrieve epoch from {}, defaulting to 0".format(path))
    return 0


def image_to_batch(image_array):
    return kimg.img_to_array(image_array)[np.newaxis]


def load_img(path):
    return kimg.load_img(path)
