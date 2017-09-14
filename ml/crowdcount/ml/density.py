from crowdcount.ml.callbacks import PredictionCheckpoint
from crowdcount.models import paths as ccp, previewer
from keras.callbacks import CSVLogger, ModelCheckpoint, TensorBoard
from keras.layers import Conv2D, MaxPooling2D
from keras.models import Sequential
import crowdcount.ml.generators as generators
import keras.optimizers
import os
import re


def train(existing_weights=None):
    model = _create_model(existing_weights)
    initial_epoch = _fetch_epoch(existing_weights)
    print(model.summary())

    model.fit_generator(generators.training(),
            generators.steps_per_epoch(),
            initial_epoch=initial_epoch,
            epochs=100 - initial_epoch,
            verbose=1,
            validation_data=generators.validation(),
            validation_steps=generators.validation_steps(),
            callbacks=_create_callbacks())

    test(model)


def test(model=None, existing_weights=None):
    if not model:
        model = _create_model(existing_weights)
    score = model.evaluate_generator(generators.validation(), steps=generators.validation_steps())
    print('Test loss:', score[0])
    print('Test accuracy:', score[1])


def predict(image, existing_weights):
    model = _create_model(existing_weights)
    y = model.predict(generators.image_to_batch(image), batch_size=1)
    previewer.save(ccp.datapath(image), ccp.output("predictions/{}".format(os.path.basename(image))), y)


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
        print("Loading weights for epoch {} from {}".format(_fetch_epoch(existing_weights), existing_weights))
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
            PredictionCheckpoint(ccp.datapath("data/shakecam/shakeshack-1504543773.jpg"))]


def _fetch_epoch(existing_weights):
    if existing_weights:
        match = re.match(r".*(?:weights\.|epoch)(\d+).*", existing_weights)
        if match:
            return int(match.group(1))
        else:
            print("Could not retrieve epoch from {}, defaulting to 0".format(existing_weights))
    return 0
