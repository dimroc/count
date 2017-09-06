import csv
import json
import numpy as np


def get(key):
    if key.startswith("data/shakecam"):
        return np.array([[100, 100]])  # Stub until shakecam is done.
    return _annotations[key]


def from_turk(path):
    dic = {}
    with open(path) as infile:
        reader = csv.DictReader(infile)
        for row in reader:
            path = _turk_url_to_key(row["Input.image_url"])
            points = _turk_points_to_annotations(row["Answer.annotation_data"])
            dic[path] = points
    return dic


def _turk_url_to_key(s3url):
    return s3url.replace("https://s3.amazonaws.com/dimroc-public", "data")


def _turk_points_to_annotations(payload):
    return [[v['left'], v['top']] for v in json.loads(payload)]


def _load():
    dic = {}
    for path in ['data/annotations/ucf.json', 'data/annotations/mall.json']:
        with open(path) as infile:
            dic.update(json.load(infile))

    return {k: np.asarray(v) for k, v in dic.items()}


_annotations = _load()
