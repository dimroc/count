from crowdcount.models import previewer
from keras.callbacks import Callback
import attr
import crowdcount.ml.generator as g
import os
import time


@attr.s
class PredictionCheckpoint(Callback):
    image_path = attr.ib()
    output_dir = attr.ib(default="tmp/predictions/{}".format(int(time.time())))

    def on_epoch_end(self, epoch, logs=None):
        x = g.image_to_batch(self.image_path)
        y = self.model.predict(x, batch_size=1)
        self._save_image(epoch, y)

    def _save_image(self, epoch, y):
        destination = "{}.jpg".format(os.path.join(self.output_dir, str(epoch)))
        previewer.save(self.image_path, destination, y)
