from crowdcount.ml.linecount import regression


def predict(x):
    return _instance.predict(x)


def train(existing_weights=None):
    _instance.train(existing_weights)


_instance = regression.Model()
