from crowdcount.ml import density, linecount, prediction
from crowdcount.models import density_map
from crowdcount.models import paths as ccp
import attr
import numpy as np

DEFAULT_VERSION = 2


def create(version=DEFAULT_VERSION):
    return Predictor(
        ccp.weights_for("density", version),
        ccp.weights_for("linecount", version),
        version)


@attr.s
class Predictor:
    density_weights = attr.ib(default=ccp.weights_for("density", DEFAULT_VERSION))
    linecount_weights = attr.ib(default=ccp.weights_for("linecount", DEFAULT_VERSION))
    version = attr.ib(default=None)

    def __attrs_post_init__(self):
        self.dm = density.Model(self.density_weights)
        self.lm = linecount.regression.Model(self.linecount_weights)
        print(self.dm.model.summary())
        print(self.lm.model.summary())

    def predict_crowd(self, image_array):
        y = self.dm.predict(image_array)
        density = np.squeeze(y)
        return prediction.Prediction(density, density.sum())

    def predict_line(self, image_array):
        y = self.dm.predict(image_array)
        density = np.squeeze(y)
        line = self.lm.predict(density) if density.shape == (180, 180) else None
        return prediction.Prediction(density, density.sum(), line)

    def predict_line_from_truth(self, path):
        truth = density_map.generate_truth(path)
        return prediction.Prediction(truth, truth.sum(), self.lm.predict(truth))
