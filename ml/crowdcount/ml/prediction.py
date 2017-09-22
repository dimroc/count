import attr


@attr.s(frozen=True)
class Prediction:
    density = attr.ib(default=None)
    line_from_truth = attr.ib(default="N/A")
    line = attr.ib(default="N/A")
