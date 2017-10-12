from matplotlib.colors import LinearSegmentedColormap
import crowdcount.models.paths as ccp
import keras.preprocessing.image as kimg
import numpy as np
import re


__all__ = ["fetch_epoch", "image_to_batch", "CMAP"]


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


def load_img(image_key):
    return kimg.load_img(ccp.datapath(image_key))


_cdict = {'red': ((0.0, 1.0, 1.0),
                 (0.15, 0.0, 0.0),
                 (0.5, 1.0, 1.0),
                 (1.0, 1.0, 1.0)),

         'green': ((0.0, 1.0, 1.0),
                   (0.15, 0.0, 0.0),
                   (0.65, 0.9, 0.9),
                   (1.0, 0.2, 0.2)),

         'blue': ((0.0, 1.0, 1.0),
                  (0.15, 0.0, 0.0),
                  (1.0, 0.2, 0.2))}


CMAP = LinearSegmentedColormap('CountingColor', _cdict)
