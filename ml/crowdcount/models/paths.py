from inflection import camelize
from numpy.random import choice as weighted_choice
from random import randint, choice
import glob
import os
import re


def datapath(path):
    """
    Support local paths: data/ucf/1.jpg
    Or floyd paths: /data/ucf/1.jpg
    """
    if 'FLOYD' in os.environ:
        return os.path.join("/", path)
    else:
        return path


def defloyd_path(path):
    return path[1:] if path.startswith("/") else path


def output(p=''):
    if 'FLOYD' in os.environ:
        return os.path.join("/output", p)
    else:
        return os.path.join("tmp", p)


def datasets():
    # yield from ['ucf', 'mall', 'shakecam']
    yield from ['mall', 'shakecam']


def random_dataset():
    """
    Lean more towards shakecam dataset because that's the point of focus
    """
    return weighted_choice(list(datasets()), 1, [0.2, 0.8])[0]


def get(dataset):
    class_name = "{}Path".format(camelize(dataset))
    return globals()[class_name]()


def random_image_path():
    return get(random_dataset()).path()


class UcfPath:
    def path(self, index=None):
        if not index:
            index = randint(1, 50)
        return datapath("data/ucf/{}.jpg".format(index))


class MallPath:
    def path(self, index=None):
        if not index:
            index = randint(1, 2000)
        return datapath("data/mall/frames/seq_00{:04}.jpg".format(index))


class ShakecamPath:
    def path(self, index=None):
        if not index:
            index = self.randindex()
        return datapath("data/shakecam/shakeshack-{}.jpg".format(index))

    def randindex(self):
        path = choice(glob.glob(datapath("data/shakecam/shakeshack-*.jpg")))
        return int(re.match(r".*shakeshack-(\d+)\.", path).group(1))
