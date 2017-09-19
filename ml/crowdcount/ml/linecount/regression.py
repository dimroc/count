from crowdcount.ml.generators import linecount as generator
from crowdcount.models import paths as ccp
from keras.callbacks import CSVLogger, ModelCheckpoint, TensorBoard
from keras.layers import Dense, Activation, Flatten, AveragePooling2D
from keras.models import Sequential
import crowdcount.ml as ml
import crowdcount.ml.callbacks as callbacks
import keras.optimizers
import os


class Model:
    def __init__(self, existing_weights=None):
        self.model = Sequential([
            AveragePooling2D(input_shape=(180, 180, 1)),
            Flatten(),
            Dense(2048),
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

        self.model.compile(loss='mean_squared_error',
                optimizer=keras.optimizers.adam(lr=1e-6, decay=5e-5),
                metrics=['mse', 'mae', 'accuracy'])

    def predict(self, x):
        return float(self.model.predict(x, batch_size=1))

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

        score = self.model.evaluate_generator(generator.validation(), steps=generator.validation_steps())
        print('Test loss:', score[0])
        print('Test accuracy:', score[1])


def _create_callbacks():
    os.makedirs(ccp.output('weights/linecount'), exist_ok=True)
    return [CSVLogger(ccp.output('keras_history.csv'), append=True),
            ModelCheckpoint(ccp.output("weights/linecount/weights.{epoch:02d}-{val_loss:.2f}.hdf5")),
            TensorBoard(log_dir=ccp.output('tensorboard')),
            callbacks.LineCountCheckpoint(ccp.datapath("data/shakecam/shakeshack-1500859164.jpg"))]
