import attr
import numpy as np
from crowdcount.ml import density, linecount, prediction
from crowdcount.models import density_map


@attr.s
class Predictor:
    density_weights = attr.ib()

    def __attrs_post_init__(self):
        self.dm = density.Model(self.density_weights)
        self.lm = linecount

    def predict(self, image):
        y = self.dm.predict(image)
        return prediction.Prediction(np.squeeze(y), *self._predict_line(image, y))

    def _predict_line(self, image, density):
        if "data/shakecam" in image:
            truth = density_map.generate_truth_batch(image, False)
            return self.lm.predict(truth), self.lm.predict(density)
        else:
            None, None
