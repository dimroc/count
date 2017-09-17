from PIL import Image
from crowdcount.models import density_map
from crowdcount.models.annotations import groundtruth
import attr
import keras.preprocessing.image as kimg
import matplotlib.pyplot as plt
import numpy as np
import os


def show(path, prediction=None, predicted_linecount=None):
    Previewer().show(path, prediction, predicted_linecount)


def save(dest, path, prediction=None, predicted_linecount=None):
    Previewer().save(dest, path, prediction, predicted_linecount)


@attr.s
class Previewer:
    CMAP = 'seismic'
    fig = attr.ib(default=plt.figure(figsize=(8, 6), dpi=100))
    just_predictions = attr.ib(default=False)
    prediction = attr.ib(default=None)

    def _normalize_input(self, path, prediction, predicted_linecount):
        self.path = path
        self.predicted_linecount = predicted_linecount
        if prediction is not None:
            self.prediction = np.squeeze(prediction)
        try:
            self.annotations = groundtruth.get(self.path)
        except KeyError:
            self.annotations = None

        try:
            self.linecount = groundtruth.get_linecount(path)
        except KeyError:
            self.linecount = None

    def show(self, path, prediction=None, predicted_linecount=None):
        self._normalize_input(path, prediction, predicted_linecount)
        print("Displaying {}".format(self.path))
        self._draw()
        plt.show(block=False)
        return input("Continue? [y]/n: ")

    def save(self, dest, path, prediction=None, predicted_linecount=None):
        self._normalize_input(path, prediction, predicted_linecount)
        print("Saving to {}".format(dest))
        self._draw()
        if self.prediction is not None and self.just_predictions:
            self._save_prediction(dest)
        else:
            self._save_charts(dest)

    def _save_prediction(self, dest):
        png = "{}.png".format(dest[0:-4])
        plt.imsave(png, self.prediction, cmap=self.CMAP)
        Image.open(png).convert("RGB").save(dest, 'JPEG', quality=100)
        os.remove(png)

    def _save_charts(self, dest):
        png = "{}.png".format(dest[0:-4])
        plt.savefig(png)  # matlabplot only supports png, so convert.
        Image.open(png).convert("RGB").save(dest, 'JPEG', quality=100)
        os.remove(png)

    def _draw(self):
        self.fig.clear()
        self.fig.suptitle("Crowd Count: {}".format(self.path))

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
        if self.linecount is not None:
            ax.set_title("Ground Truth: {:.2f}\nLine: {}".format(dm.sum(), self.linecount))
        else:
            ax.set_title("Ground Truth: {:.2f}".format(dm.sum()))

    def _render_prediction(self):
        if self.prediction is None:
            return

        ax = self.fig.add_subplot(self._next_plot_position())
        ax.imshow(self.prediction, cmap=self.CMAP)

        if self.predicted_linecount is not None:
            ax.set_title("Crowd: {:.2f}\nLine: {:.2f}".format(self.prediction.sum(), self.predicted_linecount))
        else:
            ax.set_title("Crowd: {:.2f}".format(self.prediction.sum()))

    def _reset_plot_position(self):
        self.current_plot = 1

    def _next_plot_position(self):
        subplot = "1{}{}".format(self._cols(), self.current_plot)
        self.current_plot += 1
        return subplot

    def _cols(self):
        return len([v for v in [self.path, self.annotations, self.prediction] if v is not None])
