from crowdcount.models import density_map
from crowdcount.models.annotations import groundtruth
from random import sample
import crowdcount.ml as ml
import numpy as np


_training_keys, _test_keys = groundtruth.train_test_split()


def training():
    return features_and_labels_loop(_training_keys)


def steps_per_epoch():
    return len(_training_keys)


def validation():
    return features_and_labels_loop(_test_keys)


def validation_steps():
    return len(_test_keys)


def features_and_labels_loop(keys):
    while True:
        for key in sample(keys, len(keys)):
            yield _load_features_labels(key)


def _load_features_labels(key):
    """
    We must always have batch sizes of 1 because the images can be
    of different dimensions, and numpy doesn't support arrays with
    variable widths and heights.
    """
    x = ml.image_to_batch(ml.load_img(key))
    y = density_map.generate_3d(key, groundtruth.get(key))[np.newaxis]
    return x, y
