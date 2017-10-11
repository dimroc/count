from crowdcount.ml.linecount import regression
import crowdcount.models.paths as ccp


def predict(x):
    return _instance.predict(x)


def train(existing_weights=None):
    regression.Model(existing_weights).train()


def summary():
    return _instance.model.summary()


_instance = regression.Model(ccp.weights_for("linecount", 2))
