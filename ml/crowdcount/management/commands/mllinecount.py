from crowdcount.ml import linecount
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--train', action='store_true', default=False)
        parser.add_argument('--weights', default=None)

    def handle(self, *args, **kwargs):
        if kwargs['train']:
            linecount.train(kwargs['weights'])
