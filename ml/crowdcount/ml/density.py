from crowdcount.ml.callbacks import PredictionCheckpoint
from keras.callbacks import CSVLogger, ModelCheckpoint, TensorBoard
from keras.layers import Conv2D, MaxPooling2D
from keras.models import Sequential
import crowdcount.ml.generator as generator
import crowdcount.models.annotations as groundtruth
import keras.optimizers


def train():
    model = _create_model()
    print(model.summary())
    model.compile(loss='mean_squared_error',
                  optimizer=keras.optimizers.adam(lr=0.00001, decay=0.00005),
                  metrics=['mae', 'accuracy'])

    model.fit_generator(generator.training(),
            generator.steps_per_epoch(),
            epochs=100,
            verbose=1,
            validation_data=generator.validation(),
            validation_steps=generator.validation_steps(),
            callbacks=_create_callbacks())

    score = model.evaluate_generator(generator.validation(), verbose=0)
    print('Test loss:', score[0])
    print('Test accuracy:', score[1])


def test():
    train, test = groundtruth.train_test_split()
    print(len(train), len(test))
    print('todo: test')


def _create_model():
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
    model.add(Conv2D(1, (1, 1), padding='same'))
    return model


def _create_callbacks():
    return [CSVLogger('tmp/keras_history.csv', append=True),
            ModelCheckpoint("tmp/weights.{epoch:02d}-{val_loss:.2f}.hdf5"),
            TensorBoard(log_dir='tmp/tensorboard'),
            PredictionCheckpoint("data/shakecam/shakeshack-1500836313.jpg")]
