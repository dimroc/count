from PIL import Image
from crowdcount.ml.prediction import Prediction
from crowdcount.models import density_map
from crowdcount.models.annotations import groundtruth
import attr
import keras.preprocessing.image as kimg
import matplotlib.pyplot as plt
import os


def show(path, prediction=None, line_from_truth=None):
    Previewer().show(path, prediction)


def save(dest, path, prediction=None, line_from_truth=None):
    Previewer().save(dest, path, prediction)


@attr.s
class Previewer:
    CMAP = 'seismic'
    fig = attr.ib(default=plt.figure(figsize=(8, 6), dpi=100))
    just_predictions = attr.ib(default=False)
    prediction = attr.ib(default=attr.Factory(Prediction))
    line_from_truth = attr.ib(default=attr.Factory(Prediction))

    def _normalize_input(self, path, prediction, line_from_truth):
        self.path = path
        self.prediction = prediction if prediction else Prediction()
        self.line_from_truth = line_from_truth if line_from_truth else Prediction()
        try:
            self.annotations = groundtruth.get(self.path)
        except KeyError:
            self.annotations = None

        try:
            self.true_line = groundtruth.get_linecount(path)
        except KeyError:
            self.true_line = "N/A"

    def show(self, path, prediction, line_from_truth=None):
        self._normalize_input(path, prediction, line_from_truth)
        print("Displaying {}".format(self.path))
        self._draw()
        plt.show(block=False)
        return input("Continue? [y]/n: ")

    def save(self, dest, path, prediction, line_from_truth=None):
        self._normalize_input(path, prediction, line_from_truth)
        print("Saving to {}".format(dest))
        self._draw()
        if self.prediction.density is not None and self.just_predictions:
            self._save_prediction(dest)
        else:
            self._save_charts(dest)

    def _save_prediction(self, dest):
        png = "{}.png".format(dest[0:-4])
        plt.imsave(png, self.prediction.density, cmap=self.CMAP)
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
        ax.set_title("True Crowd: {:.3}\nTrue Line: {}\nPredicted Line: {:.4}".format(dm.sum(), self.true_line, self.line_from_truth.line))

    def _render_prediction(self):
        if self.prediction.density is None:
            return

        ax = self.fig.add_subplot(self._next_plot_position())
        ax.imshow(self.prediction.density, cmap=self.CMAP)
        ax.set_title("Predicted Crowd: {:.3}\n\nPredicted Line: {:.4}".format(self.prediction.crowd, self.prediction.line))

    def _reset_plot_position(self):
        self.current_plot = 1

    def _next_plot_position(self):
        subplot = "1{}{}".format(self._cols(), self.current_plot)
        self.current_plot += 1
        return subplot

    def _cols(self):
        return len([v for v in [self.path, self.annotations, self.prediction.density] if v is not None])
