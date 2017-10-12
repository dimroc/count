from crowdcount.ml.linecount import regression


def train(existing_weights=None):
    regression.Model(existing_weights).train()
