from crowdcount.ml import density
from django.core.management.base import BaseCommand
import crowdcount.models.paths as ccp


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--image', default=None)
        parser.add_argument('--weights', default=ccp.datapath("data/weights/floyd26.epoch42.hdf5"))

    def handle(self, *args, **kwargs):
        image = kwargs['image']
        if not image:
            image = ccp.random_image_path()

        density.predict(image, kwargs['weights'])
