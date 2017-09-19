from crowdcount.ml.callbacks import DensityCheckpoint
from crowdcount.ml.generators import density as generator
from crowdcount.models import paths as ccp
from keras.callbacks import CSVLogger, ModelCheckpoint, TensorBoard
from keras.layers import Conv2D, MaxPooling2D
from keras.models import Sequential
import attr
import crowdcount.ml as ml
import keras.optimizers
import os


def train(existing_weights=None):
    model = _create_model(existing_weights)
    initial_epoch = ml.fetch_epoch(existing_weights)
    print(model.summary())

    model.fit_generator(generator.training(),
            generator.steps_per_epoch(),
            initial_epoch=initial_epoch,
            epochs=150 - initial_epoch,
            verbose=1,
            validation_data=generator.validation(),
            validation_steps=generator.validation_steps(),
            callbacks=_create_callbacks())

    test(model)


def test(model=None, existing_weights=None):
    if not model:
        model = _create_model(existing_weights)
    score = model.evaluate_generator(generator.validation(), steps=generator.validation_steps())
    print('Test loss:', score[0])
    print('Test accuracy:', score[1])


@attr.s
class Predictor:
    weights = attr.ib(default="data/weights/floyd26.epoch42.hdf5")

    def __attrs_post_init__(self):
        self.model = _create_model(self.weights)

    def predict(self, image):
        return self.model.predict(ml.image_to_batch(image), batch_size=1)


def predict(image, existing_weights):
    return Predictor(existing_weights).predict(image)


def _create_model(existing_weights=None):
    """
    Based on the model proposed by Fully Convolutional Crowd Counting On Highly Congested Scenes:
    https://arxiv.org/pdf/1612.00220.pdf
    """
    model = Sequential()
    model.add(Conv2D(36, kernel_size=(9, 9), activation='relu', input_shape=(None, None, 3), padding='same'))
    model.add(MaxPooling2D(pool_size=(2, 2), strides=(2, 2)))
    model.add(Conv2D(72, (7, 7), activation='relu', padding='same'))
    model.add(MaxPooling2D(pool_size=(2, 2), strides=(2, 2)))
    model.add(Conv2D(36, (7, 7), activation='relu', padding='same'))
    model.add(Conv2D(24, (7, 7), activation='relu', padding='same'))
    model.add(Conv2D(16, (7, 7), activation='relu', padding='same'))
    model.add(Conv2D(1, (1, 1), padding='same', kernel_initializer='random_normal'))

    if existing_weights:
        print("Loading weights for epoch {} from {}".format(ml.fetch_epoch(existing_weights), existing_weights))
        model.load_weights(existing_weights)

    return _compile_model(model)


def _compile_model(model):
    model.compile(loss='mean_squared_error',
                  optimizer=keras.optimizers.adam(lr=1e-5, decay=5e-5),
                  metrics=['mae', 'mse', 'accuracy'])
    return model


def _create_callbacks():
    os.makedirs(ccp.output('weights'), exist_ok=True)
    return [CSVLogger(ccp.output('keras_history.csv'), append=True),
            ModelCheckpoint(ccp.output("weights/weights.{epoch:02d}-{val_loss:.2f}.hdf5")),
            TensorBoard(log_dir=ccp.output('tensorboard')),
            DensityCheckpoint(ccp.datapath("data/shakecam/shakeshack-1504543773.jpg"))]
