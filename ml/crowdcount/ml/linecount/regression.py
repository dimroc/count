from crowdcount.ml.linecount import mask
from keras.layers import Dense, Activation
from keras.models import Sequential
from crowdcount.ml.generators import linecount as generator
import crowdcount.ml as ml
import keras.optimizers


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
            self.initial_epoch = ml.fetch_epoch(existing_weights)
        else:
            self.initial_epoch = 0

        self.model.compile(loss='mean_absolute_error',
                optimizer=keras.optimizers.adam(),
                metrics=['mae', 'mse', 'accuracy'])

    def predict(self, x):
        return mask.predict(x)

    def train(self):
        print(self.model.summary())
        self.model.fit_generator(generator.training(),
                generator.steps_per_epoch(),
                initial_epoch=self.initial_epoch,
                epochs=100 - self.initial_epoch,
                verbose=1,
                validation_data=generator.validation(),
                validation_steps=generator.validation_steps(),
                callbacks=_create_callbacks())
