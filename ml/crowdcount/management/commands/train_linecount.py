from crowdcount.ml import linecount
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--file', default=None)

    def handle(self, *args, **kwargs):
        linecount.train(kwargs['file'])
