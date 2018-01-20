from inflection import camelize
from numpy.random import choice as weighted_choice
from random import randint, choice
import glob
import os
import re

package_directory = os.path.normpath(os.path.join(os.path.dirname(os.path.abspath(__file__)), "../.."))


def weights_for(model_type, version):
    """
    e.g.
    model_type = "linecount"
    version = 2
    result: /User/dimroc/counting/ml/data/weights/linecount/v2.somenote.hdf5
    """
    pattern = os.path.join(package_directory, "data/weights", model_type, "v{}.*".format(version))
    versioned_filename = glob.glob(pattern)[0]
    return os.path.join(model_type, versioned_filename)


def datapath(path):
    """
    Support local paths: data/ucf/1.jpg
    Or floyd paths: /data/ucf/1.jpg
    """
    if 'FLOYD' in os.environ:
        return os.path.join("/", path)
    else:
        return os.path.join(package_directory, path)


def output(p=''):
    if 'FLOYD' in os.environ:
        return os.path.join("/output", p)
    else:
        return os.path.join(package_directory, "tmp", p)


def datasets():
    # yield from ['ucf', 'mall', 'shakecam']
    yield from ['mall', 'shakecam']


def random_dataset():
    """
    Lean more towards shakecam dataset because that's the point of focus
    """
    return weighted_choice(list(datasets()), 1, [0.2, 0.8])[0]


def get(dataset):
    class_name = "{}Key".format(camelize(dataset))
    return globals()[class_name]()


def random_image_path():
    return get(random_dataset()).path()


class UcfKey:
    def key_for(self, index=None):
        if not index:
            index = randint(1, 50)
        return "data/ucf/{}.jpg".format(index)


class MallKey:
    def key_for(self, index=None):
        if not index:
            index = randint(1, 2000)
        return "data/mall/frames/seq_00{:04}.jpg".format(index)


class ShakecamKey:
    def key_for(self, index=None):
        if not index:
            index = self.randindex()
        return "data/shakecam/shakeshack-{}.jpg".format(index)

    def from_index(self, index=None):
        path = "data/shakecam"
        onlyfiles = sorted([os.path.join(path, f) for f in os.listdir(path) if os.path.isfile(os.path.join(path, f)) and f.startswith("shake")])
        if index:
            start = onlyfiles.index(self.file_from_index(index))
        else:
            start = 0
        return onlyfiles[start:]

    def randindex(self):
        path = choice(glob.glob(datapath("data/shakecam/shakeshack-*.jpg")))
        return int(re.match(r".*shakeshack-(\d+)\.", path).group(1))

    def file_from_index(self, index):
        return "data/shakecam/shakeshack-{}.jpg".format(index)
