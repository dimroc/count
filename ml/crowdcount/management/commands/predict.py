from crowdcount.ml import density
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--image', default="data/shakecam/shakeshack-1501115429.jpg")
        parser.add_argument('--weights', default="tmp/floyd/21/weights.72-0.00.hdf5")

    def handle(self, *args, **kwargs):
        density.predict(kwargs['image'], kwargs['weights'])
