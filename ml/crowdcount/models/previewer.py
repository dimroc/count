from PIL import Image
from crowdcount.ml.prediction import Prediction, PredictionDecorator
from crowdcount.models import density_map
from crowdcount.models.annotations import groundtruth
import attr
import crowdcount.ml as ml
import matplotlib.pyplot as plt
import os


def show(image_key, prediction=None, line_from_truth=None):
    Previewer().show(image_key, prediction)


def save(dest, image_key, prediction=None, line_from_truth=None):
    Previewer().save(dest, image_key, prediction)


@attr.s
class Previewer:
    CMAP = ml.CMAP
    fig = attr.ib(default=plt.figure(figsize=(8, 6), dpi=100))
    just_predictions = attr.ib(default=False)
    prediction = attr.ib(default=attr.Factory(Prediction))
    line_from_truth = attr.ib(default=attr.Factory(Prediction))

    def _normalize_input(self, image_key, prediction, line_from_truth):
        self.image_key = image_key
        self.prediction = prediction if prediction else Prediction()
        self.line_from_truth = line_from_truth if line_from_truth else Prediction()

        self.prediction = PredictionDecorator(self.prediction)
        self.line_from_truth = PredictionDecorator(self.line_from_truth)
        try:
            self.annotations = groundtruth.get(self.image_key)
        except KeyError:
            self.annotations = None

        try:
            self.true_line = groundtruth.get_linecount(image_key)
        except KeyError:
            self.true_line = "N/A"

    def show(self, image_key, prediction=None, line_from_truth=None):
        self._normalize_input(image_key, prediction, line_from_truth)
        print("Displaying {}".format(self.image_key))
        self._draw()
        plt.show(block=False)

    def save(self, dest, image_key, prediction=None, line_from_truth=None):
        self._normalize_input(image_key, prediction, line_from_truth)
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
        self.fig.suptitle("Image: {}".format(self.image_key))

        self._reset_plot_position()
        self._render_img()
        self._render_groundtruth()
        self._render_prediction()

    def _render_img(self):
        img = ml.load_img(self.image_key)
        ax = self.fig.add_subplot(self._next_plot_position())
        ax.imshow(img)

        if self.annotations is not None and self.annotations.any():
            ax.plot(self.annotations[:, 0], self.annotations[:, 1], 'c+')
            ax.set_title("Annotations: {}".format(len(self.annotations)))

    def _render_groundtruth(self):
        if self.annotations is None:
            return

        ax = self.fig.add_subplot(self._next_plot_position())
        dm = density_map.generate(self.image_key, self.annotations)
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
        return len([v for v in [self.image_key, self.annotations, self.prediction.density] if v is not None])
