from crowdcount.models import ml
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--train', action='store_true', default=False)
        parser.add_argument('--test', action='store_true', default=False)

    def handle(self, *args, **kwargs):
        if kwargs['train']:
            ml.train()

        if kwargs['test']:
            ml.test()
