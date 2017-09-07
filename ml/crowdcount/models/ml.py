from keras.layers import Dense, Activation
from keras.models import Sequential
import numpy as np


def train():
    model = Sequential()
    model.add(Dense(units=5, input_dim=5))
    model.add(Activation('relu'))
    model.add(Dense(units=2))
    model.add(Activation('softmax'))
    model.compile(loss='categorical_crossentropy', optimizer='sgd', metrics=['accuracy'])

    # x_train and y_train are Numpy arrays --just like in the Scikit-Learn API.
    model.fit(np.random.rand(5, 5), np.random.rand(5, 2), epochs=5, batch_size=32)
    print(model.evaluate(np.random.rand(1, 5), np.random.rand(1, 2), batch_size=128))


def test():
    print('todo: test')
