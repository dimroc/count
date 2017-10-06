import attr
import crowdcount.models.paths as ccp
import csv
import json
import numpy as np
import os
import sklearn.model_selection as sk


__all__ = ["groundtruth", "Annotations", "from_turk"]


@attr.s
class Annotations():
    table = attr.ib(default=attr.Factory(dict))
    linecounts = attr.ib(default=attr.Factory(dict))

    def get(self, image_key):
        return self.table[image_key][:]

    def get_linecount(self, image_key):
        return self.linecounts[image_key]

    def keys(self):
        return self.table.keys()

    def reload(self):
        """
        Reload annotations stored in data/annotations
        """
        self.table = self._load_annotations()
        self.linecounts = self._load_linecounts()
        return self

    def train_test_split(self, only_linecounts=False):
        """
        Take x% from each data source to have consistent distribution
        across training and test. Retrieves from self.keys() to ensure
        we have annotations for said file.
        """

        def with_linecount(key):
            return key in self.linecounts or not only_linecounts

        def in_dataset(key, ds):
            return key.startswith("data/{}".format(ds))  # e.g. data/ucf

        train, test = [], []
        for ds in ccp.datasets():
            keys = [k for k in self.keys() if in_dataset(k, ds) and with_linecount(k)]
            traintmp, testtmp = sk.train_test_split(sorted(keys), test_size=0.1, random_state=0)
            train.extend(traintmp)
            test.extend(testtmp)

        return train, test

    def _load_linecounts(self):
        """
        Loads shakecam line counts, which can differ dramatically
        from total crowd count.
        """
        with open(ccp.datapath("data/mturk/line_counts.csv")) as csvfile:
            reader = csv.reader(csvfile)
            return {row[0]: int(row[1]) for row in reader}

    def _load_annotations(self):
        dic = {}
        paths = [ccp.datapath("data/annotations/{}.json".format(v)) for v in ccp.datasets()]
        for path in paths:
            if os.path.isfile(path):
                with open(path) as infile:
                    dic.update(json.load(infile))
            else:
                print("Warning: {} not found".format(path))

        return {k: np.asarray(v) for k, v in dic.items()}


groundtruth = Annotations().reload()


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
