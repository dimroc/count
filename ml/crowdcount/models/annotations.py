import json
import numpy as np


def get(key):
    if key.startswith("data/shakecam"):
        return np.array([[100, 100]])  # Stub until shakecam is done.
    return _annotations[key]


def _load():
    dic = {}
    for path in ['data/annotations/ucf.json', 'data/annotations/mall.json']:
        with open(path) as infile:
            dic.update(json.load(infile))

    return {k: np.asarray(v) for k, v in dic.items()}


_annotations = _load()
