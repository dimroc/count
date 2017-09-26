import attr
import numpy as np


@attr.s(frozen=True)
class Prediction:
    density = attr.ib(default=None, convert=np.squeeze)
    crowd = attr.ib(default="N/A")
    line = attr.ib(default="N/A")

    def __str__(self):
        dm = self.density.shape if self.density is not None else "N/A"
        return "Density Map: {} Crowd: {} Line: {}".format(dm, self.crowd, self.line)
