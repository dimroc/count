import attr
import numpy as np


def _density_converter(original):
    if original is not None:
        return np.squeeze(original)
    else:
        return None


@attr.s(frozen=True)
class Prediction:
    density = attr.ib(default=None, convert=_density_converter)
    crowd = attr.ib(default=None)
    line = attr.ib(default=None)

    def __str__(self):
        dm = self.density.shape if self.density is not None else "N/A"
        return "Density Map: {} Crowd: {} Line: {}".format(dm, self.crowd, self.line)


@attr.s(frozen=True)
class PredictionDecorator:
    prediction = attr.ib()

    def __getattr__(self, name):
        return getattr(self.prediction, name)

    @property
    def crowd(self):
        return self.prediction.crowd if self.prediction.crowd is not None else "N/A"

    @property
    def line(self):
        return self.prediction.line if self.prediction.line is not None else "N/A"
