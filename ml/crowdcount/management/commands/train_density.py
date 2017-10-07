from crowdcount.ml import density
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--file', default=None)
        parser.add_argument('--test', action='store_true', default=False)

    def handle(self, *args, **kwargs):
        if kwargs['test']:
            density.test(model_path=kwargs['file'])
        else:
            density.train(kwargs['file'])
