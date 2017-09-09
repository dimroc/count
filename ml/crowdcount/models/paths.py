from inflection import camelize
from random import randint, choice
import glob
import re


def datasets():
    yield from ['ucf', 'mall', 'shakecam']


def get(dataset):
    class_name = "{}Path".format(camelize(dataset))
    return globals()[class_name]()


class UcfPath:
    def path(self, index=None):
        if not index:
            index = randint(1, 50)
        return "data/ucf/{}.jpg".format(index)


class MallPath:
    def path(self, index=None):
        if not index:
            index = randint(1, 2000)
        return "data/mall/frames/seq_00{:04}.jpg".format(index)


class ShakecamPath:
    def path(self, index=None):
        if not index:
            index = self.randindex()
        return "data/shakecam/shakeshack-{}.jpg".format(index)

    def randindex(self):
        path = choice(glob.glob('data/shakecam/shakeshack-*.jpg'))
        return int(re.match(r".*shakeshack-(\d+)\.", path).group(1))
