from PIL import Image
from crowdcount.models import density_map
from crowdcount.models.annotations import groundtruth
import attr
import keras.preprocessing.image as kimg
import matplotlib.pyplot as plt
import numpy as np
import os


def show(path, prediction=None):
    Previewer().show(path, prediction)


def save(path, dest, prediction=None):
    Previewer().save(path, prediction, dest)


@attr.s
class Previewer:
    CMAP = 'seismic'
    fig = attr.ib(default=plt.figure(figsize=(8, 6), dpi=100))
    prediction = attr.ib(default=None)

    def _normalize_input(self, path, prediction):
        self.path = path
        if prediction is not None:
            self.prediction = np.squeeze(prediction)
        try:
            self.annotations = groundtruth.get(self.path)
        except KeyError:
            self.annotations = None

    def show(self, path, prediction):
        self._normalize_input(path, prediction)
        print("Displaying {}".format(self.path))
        self._draw()
        plt.show(block=False)
        return input("Continue? [y]/n: ")

    def save(self, path, prediction, dest):
        self._normalize_input(path, prediction)
        print("Saving to {}".format(dest))
        self._draw()
        png = "{}.png".format(dest[0:-4])
        plt.savefig(png)  # matlabplot only supports png, so convert.
        Image.open(png).convert("RGB").save(dest, 'JPEG', quality=100)
        os.remove(png)

    def _draw(self):
        self.fig.clear()
        self.fig.suptitle('Crowd Count')

        self._reset_plot_position()
        self._render_img()
        self._render_groundtruth()
        self._render_prediction()

    def _render_img(self):
        img = kimg.load_img(self.path)
        ax = self.fig.add_subplot(self._next_plot_position())
        ax.imshow(img)

        if self.annotations is not None and self.annotations.any():
            ax.plot(self.annotations[:, 0], self.annotations[:, 1], 'r+')
            ax.set_title("Annotations: {}".format(len(self.annotations)))

    def _render_groundtruth(self):
        if self.annotations is None:
            return

        ax = self.fig.add_subplot(self._next_plot_position())
        dm = density_map.generate(self.path, self.annotations)
        ax.imshow(dm, cmap=self.CMAP)
        ax.set_title("Ground Truth: {0:.2f}".format(dm.sum()))

    def _render_prediction(self):
        if self.prediction is None:
            return

        ax = self.fig.add_subplot(self._next_plot_position())
        ax.imshow(self.prediction, cmap=self.CMAP)
        ax.set_title("Prediction: {0:.2f}".format(self.prediction.sum()))

    def _reset_plot_position(self):
        self.current_plot = 1

    def _next_plot_position(self):
        subplot = "1{}{}".format(self._cols(), self.current_plot)
        self.current_plot += 1
        return subplot

    def _cols(self):
        return len([v for v in [self.path, self.annotations, self.prediction] if v is not None])
