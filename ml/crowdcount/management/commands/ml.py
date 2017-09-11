from crowdcount.ml import density
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--train', action='store_true', default=False)
        parser.add_argument('--weights', default=None)
        parser.add_argument('--test', action='store_true', default=False)

    def handle(self, *args, **kwargs):
        if kwargs['train']:
            density.train(kwargs['weights'])

        if kwargs['test']:
            density.test()
