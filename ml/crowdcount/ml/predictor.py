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
        print(self.dm.model.summary())
        print(self.lm.summary())

    def predict(self, image_array):
        y = self.dm.predict(image_array)
        density = np.squeeze(y)
        line = self.lm.predict(density) if density.shape == (180, 180) else "N/A"
        return prediction.Prediction(density, density.sum(), line)

    def predict_from_truth(self, path):
        truth = density_map.generate_truth(path)
        return prediction.Prediction(truth, truth.sum(), self.lm.predict(truth))
