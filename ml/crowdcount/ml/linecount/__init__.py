from crowdcount.ml.linecount import regression


def predict(x):
    return _instance.predict(x)


def train(existing_weights=None):
    regression.Model(existing_weights).train()


_instance = regression.Model()
