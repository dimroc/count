from crowdcount.ml import density
from crowdcount.models import paths as ccp, previewer
from django.core.management.base import BaseCommand
import os


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--image', default=None)
        parser.add_argument('--weights', default=ccp.datapath("data/weights/floyd26.epoch42.hdf5"))
        parser.add_argument('--save', action='store_true', default=False)

    def handle(self, *args, **kwargs):
        image = kwargs['image']
        if not image:
            image = ccp.random_image_path()

        y = density.predict(image, kwargs['weights'])
        if kwargs['save']:
            dest = ccp.output("predictions/{}".format(os.path.basename(image)))
            previewer.save(image, dest, y)
        else:
            previewer.show(image, y)
