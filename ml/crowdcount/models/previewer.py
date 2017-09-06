from inflection import camelize
from random import randint, choice
import glob
import matplotlib.image as mpimg
import matplotlib.pyplot as plt
import re


def get(dataset):
    class_name = "{}Previewer".format(camelize(dataset))
    return globals()[class_name]()


class BasePreviewer():
    def show(self, index=None):
        raise RuntimeError()

    def display(self, path, cmap=None):
        print("Displaying {}".format(path))
        img = mpimg.imread(path)
        plt.imshow(img, cmap=cmap)
        plt.show()


class UcfPreviewer(BasePreviewer):
    def show(self, index=None):
        if not index:
            index = randint(1, 50)
        self.display("data/ucf/{}.jpg".format(index), "gray")


class MallPreviewer(BasePreviewer):
    def show(self, index=None):
        if not index:
            index = randint(1, 2000)
        self.display("data/mall_dataset/frames/seq_00{:04}.jpg".format(index))


class ShakecamPreviewer(BasePreviewer):
    def show(self, index=None):
        if not index:
            index = self.randindex()
        self.display("data/shakecam/shakeshack-{}.jpg".format(index))

    def randindex(self):
        path = choice(glob.glob('data/shakecam/shakeshack-*.jpg'))
        return int(re.match(r".*shakeshack-(\d+)\.", path).group(1))
