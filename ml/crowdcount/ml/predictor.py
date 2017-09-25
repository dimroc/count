from crowdcount.ml import density, linecount, prediction
from crowdcount.models import density_map
from crowdcount.models import paths as ccp
import attr
import numpy as np

DEFAULT_WEIGHTS = ccp.datapath("data/weights/floyd26.epoch42.hdf5")


@attr.s
class Predictor:
    density_weights = attr.ib(default=DEFAULT_WEIGHTS)

    def __attrs_post_init__(self):
        self.dm = density.Model(self.density_weights)
        self.lm = linecount

    def predict(self, image):
        y = self.dm.predict(image)
        density = np.squeeze(y)
        return prediction.Prediction(density, density.sum(), *self._predict_line(image, y))

    def _predict_line(self, image, density):
        if "data/shakecam" in image:
            truth = density_map.generate_truth_batch(image, False)
            return self.lm.predict(truth), self.lm.predict(density)
        else:
            None, None
