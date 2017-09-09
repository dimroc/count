from crowdcount.models import density_map
from crowdcount.models.annotations import groundtruth
from random import sample
import keras.preprocessing.image as kimg
import numpy as np


_training_paths, _test_paths = groundtruth.train_test_split()


def training():
    return features_and_labels_loop(_training_paths)


def steps_per_epoch():
    return len(_training_paths)


def validation():
    return features_and_labels_loop(_test_paths)


def validation_steps():
    return len(_test_paths)


def features_and_labels_loop(paths):
    while True:
        for path in sample(paths, len(paths)):
            yield _load_features_labels(path)


def image_to_batch(path):
    return kimg.img_to_array(kimg.load_img(path))[np.newaxis]


def _load_features_labels(path):
    """
    We must always have batch sizes of 1 because the images can be
    of different dimensions, and numpy doesn't support arrays with
    variable widths and heights.
    """
    return image_to_batch(path), density_map.generate_3d(path, groundtruth.get(path))[np.newaxis]
