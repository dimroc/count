from crowdcount.ml.linecount import mask
from keras.layers import Dense, Activation
from keras.models import Sequential
import crowdcount.ml.generators as generators
import keras.optimizers


def predict(x):
    return _instance.predict(x)


def train(existing_weights=None):
    _instance.train(existing_weights)


class Model:
    def __init__(self, existing_weights=None):
        self.model = Sequential([
            Dense(4096, input_shape=(180, 180)),
            Activation('relu'),
            Dense(32),
            Activation('relu'),
            Dense(1)
        ])

        if existing_weights:
            print("Loading weights for linecount from {}".format(existing_weights))
            self.model.load_weights(existing_weights)

        self.model.compile(loss='mean_absolute_error',
                optimizer=keras.optimizers.adam(),
                metrics=['mae', 'mse', 'accuracy'])

    def train(self, existing_weights=None):
        pass

    def predict(self, x):
        return mask.predict(x)


_instance = Model()
