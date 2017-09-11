from crowdcount.models import previewer, paths as ccp
from keras.callbacks import Callback
import attr
import crowdcount.ml.generators as g
import os
import time


@attr.s
class PredictionCheckpoint(Callback):
    image_path = attr.ib()
    output_dir = attr.ib(default=ccp.output("predictions/{}".format(int(time.time()))))

    def on_train_begin(self, logs=None):
        self._save_prediction("begin")

    def on_epoch_end(self, epoch, logs=None):
        self._save_prediction("epoch_{}".format(epoch))

    def _save_prediction(self, label):
        x = g.image_to_batch(self.image_path)
        y = self.model.predict(x, batch_size=1)
        self._save_image(label, y)

    def _save_image(self, label, y):
        os.makedirs(self.output_dir, exist_ok=True)
        destination = "{}.jpg".format(os.path.join(self.output_dir, label))
        previewer.save(self.image_path, destination, y)
