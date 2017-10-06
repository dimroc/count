from django.core.management.base import BaseCommand
from crowdcount.models import previewer, paths


class Command(BaseCommand):
    def add_arguments(self, parser):
        # Positional arguments: https://docs.python.org/3/library/argparse.html#nargs
        parser.add_argument('--dataset', type=str, default='shakecam')
        parser.add_argument('--index', type=int)

    def handle(self, *args, **kwargs):
        dataset = kwargs['dataset']
        index = kwargs['index']
        previewer.show(paths.get(dataset).key_for(index))
