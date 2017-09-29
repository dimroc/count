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
    crowd = attr.ib(default="N/A")
    line = attr.ib(default="N/A")

    def __str__(self):
        dm = self.density.shape if self.density is not None else "N/A"
        return "Density Map: {} Crowd: {} Line: {}".format(dm, self.crowd, self.line)
