import attr


@attr.s(frozen=True)
class Prediction:
    density = attr.ib(default=None)
    crowd = attr.ib(default="N/A")
    line_from_truth = attr.ib(default="N/A")
    line = attr.ib(default="N/A")
