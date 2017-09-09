from crowdcount.models import density_map
from crowdcount.models.annotations import groundtruth
import keras.preprocessing.image as kimg
import keras.backend.common as K
from random import sample
import numpy as np


_training_paths, _test_paths = groundtruth.train_test_split()


def _load_features_labels(path):
    # TODO: Clean up into a class and allow batch sizes.
    x = kimg.img_to_array(kimg.load_img(path))
    y = density_map.generate_fcn(path, groundtruth.get(path))
    batch_x = np.zeros((1,) + x.shape, dtype=K.floatx())
    batch_y = np.zeros((1,) + y.shape, dtype=K.floatx())
    batch_x[0], batch_y[0] = x, y
    return batch_x, batch_y


def training():
    while True:
        for path in sample(_training_paths, steps_per_epoch()):
            yield _load_features_labels(path)


def steps_per_epoch():
    return len(_training_paths)


def validation():
    while True:
        for path in sample(_test_paths, validation_steps()):
            yield _load_features_labels(path)


def validation_steps():
    return len(_test_paths)
