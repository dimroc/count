import attr
import csv
import json
import numpy as np


@attr.s
class Annotations():
    table = attr.ib(default=attr.Factory(dict))

    def get(self, key):
        return self.table[key]

    def reload(self):
        self.table = self._load()
        return self

    def from_turk(self, path):
        dic = {}
        with open(path) as infile:
            reader = csv.DictReader(infile)
            for row in reader:
                path = self._turk_url_to_key(row["Input.image_url"])
                points = self._turk_points_to_annotations(row["Answer.annotation_data"])
                dic[path] = points
        return dic

    def _turk_url_to_key(self, s3url):
        return s3url.replace("https://s3.amazonaws.com/dimroc-public", "data")

    def _turk_points_to_annotations(self, payload):
        return [[v['left'], v['top']] for v in json.loads(payload)]

    def _load(self):
        dic = {}
        paths = ["data/annotations/{}.json".format(v) for v in ['ucf', 'mall', 'shakecam']]
        for path in paths:
            with open(path) as infile:
                dic.update(json.load(infile))

        return {k: np.array(v, ndmin=2) for k, v in dic.items()}


annotations = Annotations().reload()
