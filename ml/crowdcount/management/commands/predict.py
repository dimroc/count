from crowdcount.ml import density
from crowdcount.models import paths as ccp, previewer as pwr, annotations as ants
from django.core.management.base import BaseCommand
from random import shuffle
import os


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--image', default=None)
        parser.add_argument('--weights', default=ccp.datapath("data/weights/floyd26.epoch42.hdf5"))
        parser.add_argument('--save', action='store_true', default=False)

    def handle(self, *args, **kwargs):
        images = kwargs['image']
        if not kwargs['image']:
            _, images = ants.groundtruth.train_test_split()
            shuffle(images)
        else:
            images = [kwargs['image']]

        predictor = density.Predictor(kwargs['weights'])
        self._predict_images(images, predictor, kwargs['save'])

    def _predict_images(self, images, predictor, save=False):
        previewer = pwr.Previewer()
        for image in images:
            y = predictor.predict(image)
            if save:
                dest = ccp.output("predictions/{}".format(os.path.basename(image)))
                previewer.save(image, dest, y)
            else:
                if previewer.show(image, y) == 'n':
                    break
