from crowdcount.ml import fetch_epoch, image_to_batch
from crowdcount.ml.generators import linecount as generator
from crowdcount.models import paths as ccp
from keras.callbacks import CSVLogger, ModelCheckpoint, TensorBoard
from keras.layers import Dense, Flatten, MaxPooling2D, Dropout
from keras.models import Sequential
import crowdcount.ml.callbacks as callbacks
import crowdcount.models.mask as mask
import keras.optimizers
import os


class Model:
    def __init__(self, existing_weights=None):
        self.model = Sequential([
            MaxPooling2D(input_shape=(180, 180, 1)),
            Flatten(),
            Dense(512, activation='relu'),
            Dropout(0.5),
            Dense(512, activation='relu'),
            Dropout(0.5),
            Dense(1, activation='relu')
        ])

        if existing_weights:
            print("Loading weights for linecount from {}".format(existing_weights))
            self.model.load_weights(existing_weights)
            self.initial_epoch = fetch_epoch(existing_weights)
        else:
            self.initial_epoch = 0

        self.model.compile(loss='mean_squared_error',
                optimizer=keras.optimizers.adam(lr=1e-5, decay=5e-7),
                metrics=['mse', 'mae', 'accuracy'])

    def predict(self, image_array):
        x = image_array * mask.array
        return float(self.model.predict(image_to_batch(x), batch_size=1))

    def train(self):
        print(self.model.summary())
        self.model.fit_generator(generator.training(),
                generator.steps_per_epoch(),
                initial_epoch=self.initial_epoch,
                epochs=400 - self.initial_epoch,
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
            ModelCheckpoint(ccp.output("weights/linecount/weights.{epoch:03d}-{val_loss:.2f}.hdf5")),
            TensorBoard(log_dir=ccp.output('tensorboard')),
            callbacks.LineCountCheckpoint("data/shakecam/shakeshack-1500859164.jpg")]
