# Backend of Count

Houses all data science, image manipulation, and machine learning software.


Setup:

```
# Install docker for mac
brew install django-completion
pyenv install conda # or wtever u do to get conda going
conda-env create -f environment.yml # or something like this
pip install -g floyd-cli

./bin/download_data
./bin/process_shakecam

./manage.py predict
```


---

### Training notes


```
sgd:
  optimizer=keras.optimizers.sgd(lr=1e-7, momentum=0.9, decay=5e-4),

adam:
optimizer=keras.optimizers.adam(lr=0.00001, decay=0.00005), # Had loss function of mean_squared_error
epoch 30:
optimizer=keras.optimizers.adam(lr=1e-7, decay=5e-4), # Had loss function of mean_absolute_error



run 20:
optimizer=keras.optimizers.adam(lr=1e-7, decay=5e-4), # Had loss function of mean_absolute_error

run 21:
optimizer=keras.optimizers.adam(lr=1e-6, decay=5e-4), # Had loss function of mean_square_error

run 23:
only using shakecam data and mean_square_error

run 24:
lr=1e-8 using only shakecam data

run 25:
like 24 but w loss function of mean_absolute_error

run 26: # Best one yet?
    model.compile(loss='mean_squared_error',
                  optimizer=keras.optimizers.adam(lr=1e-5, decay=5e-5),
                  metrics=['mae', 'mse', 'accuracy'])

run 27:  # Looking like a garbage run
    model.compile(loss='mean_absolute_error',
                  optimizer=keras.optimizers.adam(lr=1e-4, decay=5e-5),
                  metrics=['mae', 'mse', 'accuracy'])


run 30:
  \_instance = regression.Model("tmp/floyd/linecount/30/weights.95-42.84.hdf5")
  ml linecount
  self.model.compile(loss='mean_squared_error',
          optimizer=keras.optimizers.adam(lr=1e-4, decay=5e-5),
          metrics=['mse', 'mae', 'accuracy'])
        self.model = Sequential([
            Flatten(input_shape=(180, 180)),
            Dense(4096),
            Activation('relu'),
            Dense(32),
            Activation('relu'),
            Dense(1)
        ])
        Total params: 132,845,633
  NO MASK

run 31:  #GARBAGE # Started: Have normal predictions use masks
  ml linecount
  self.model.compile(loss='mean_squared_error',
          optimizer=keras.optimizers.adam(lr=1e-5, decay=5e-5),
          metrics=['mse', 'mae', 'accuracy'])
  w MASK
  # Learning rate was too high


run 2:  # reduced size
  ml linecount
  self.model.compile(loss='mean_squared_error',
          optimizer=keras.optimizers.adam(lr=1e-6),
          metrics=['mse', 'mae', 'accuracy'])
        self.model = Sequential([
            AveragePooling2D(input_shape=(180, 180)),
            Flatten(),
            Dense(2048),
            Activation('relu'),
            Dense(32),
            Activation('relu'),
            Dense(1)
        ])
        Total params: 16,656,449
  w MASK

run 4:  # reduced size. Looking like garbage
  ml linecount
  self.model.compile(loss='mean_squared_error',
          optimizer=keras.optimizers.adam(lr=1e-4, decay=5e-4),
          metrics=['mse', 'mae', 'accuracy'])
        self.model = Sequential([
            AveragePooling2D(input_shape=(180, 180)),
            Flatten(),
            Dense(2048),
            Activation('relu'),
            Dense(32),
            Activation('relu'),
            Dense(1)
        ])
        Total params: 16,656,449
  w MASK


run 5: # super small size
  ml linecount
      self.model = Sequential([
        AveragePooling2D(input_shape=(180, 180, 1)),
        Flatten(),
        Dense(1024, activation='relu'),
        Dense(1, activation='relu')
    ])

    if existing_weights:
        print("Loading weights for linecount from {}".format(existing_weights))
        self.model.load_weights(existing_weights)
        self.initial_epoch = ml.fetch_epoch(existing_weights)
    else:
        self.initial_epoch = 0

    self.model.compile(loss='mean_squared_error',
            optimizer=keras.optimizers.adam(lr=1e-5, decay=5e-4),
            metrics=['mse', 'mae', 'accuracy'])
    w MASK
    Total Params: 8,296,449

run 6:
        self.model = Sequential([
            AveragePooling2D(input_shape=(180, 180, 1)),
            Flatten(),
            Dense(4096, activation='relu'),
            Dense(1, activation='relu')
        ])

        self.model.compile(loss='mean_squared_error',
                optimizer=keras.optimizers.adam(lr=1e-6),
                metrics=['mse', 'mae', 'accuracy'])
      w MASK
      Total params: 33,185,793

run 7: # super small but deep size
        self.model = Sequential([
            MaxPooling2D(input_shape=(180, 180, 1)),
            Flatten(),
            Dense(1024, activation='relu'),
            Dense(1024, activation='relu'),
            Dense(1, activation='relu')
        ])

        self.model.compile(loss='mean_squared_error',
                optimizer=keras.optimizers.adam(lr=1e-5, decay=5e-4),
                metrics=['mse', 'mae', 'accuracy'])
    w MASK
    Total params: 9,346,049

run 9: # extra small but deep size. Promising, current winner!
        self.model = Sequential([
            MaxPooling2D(input_shape=(180, 180, 1)),
            Flatten(),
            Dense(512, activation='relu'),
            Dense(1, activation='relu')
        ])

        self.model.compile(loss='mean_squared_error',
                optimizer=keras.optimizers.adam(lr=1e-4, decay=5e-6), # it's actually 6
                metrics=['mse', 'mae', 'accuracy'])
    w MASK
    Total params: 4,148,225

run 10: # extra small but deep size
        self.model = Sequential([
            MaxPooling2D(input_shape=(180, 180, 1)),
            Flatten(),
            Dense(512, activation='relu'),
            Dense(1, activation='relu')
        ])

        self.model.compile(loss='mean_squared_error',
                optimizer=keras.optimizers.adam(lr=1e-5),
                metrics=['mse', 'mae', 'accuracy'])
    w MASK
    Total params: 4,148,225

run 14: # extra small but deep size
        self.model = Sequential([
            MaxPooling2D(input_shape=(180, 180, 1)),
            Flatten(),
            Dense(512, activation='relu'),
            Dense(512, activation='relu'),
            Dense(1, activation='relu')
        ])

        self.model.compile(loss='mean_squared_error',
                optimizer=keras.optimizers.adam(lr=1e-5, decay=5e-7),
                metrics=['mse', 'mae', 'accuracy'])

    w MASK
    Total params: 4,148,225

run 16: xs, deep, w dropout
        self.model = Sequential([
            MaxPooling2D(input_shape=(180, 180, 1)),
            Flatten(),
            Dense(512, activation='relu'),
            Dropout(0.5),
            Dense(512, activation='relu'),
            Dropout(0.5),
            Dense(1, activation='relu')
        ])

        self.model.compile(loss='mean_squared_error',
                optimizer=keras.optimizers.adam(lr=1e-5, decay=5e-7),
                metrics=['mse', 'mae', 'accuracy'])
    w MASK
    Total params: 4,148,225

TODO:
- Get more line count data via liz or mechanical turk
- Redo loss function for conv ml
- Increase complexity and fidelity of top conv ml (9x9 throws away too much too soon)
- Hyper parameters worth tweaking: gaussian kernel
- Create a model based on DenseNet but chop off the dense layers?
- Have a two column approach that does both? One does shallow one goes deep

```
