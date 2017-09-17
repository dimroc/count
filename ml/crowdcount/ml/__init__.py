import keras.preprocessing.image as kimg
import numpy as np
import re


def fetch_epoch(path):
    if path:
        match = re.match(r".*(?:weights\.|epoch)(\d+).*", path)
        if match:
            return int(match.group(1))
        else:
            print("Could not retrieve epoch from {}, defaulting to 0".format(path))
    return 0


def image_to_batch(path):
    return kimg.img_to_array(kimg.load_img(path))[np.newaxis]
