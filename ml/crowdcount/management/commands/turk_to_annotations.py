from crowdcount.models import annotations
from django.core.management.base import BaseCommand
import json


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--input', type=str, required=True)
        parser.add_argument('--output', type=str, default='data/annotations/shakecam.json')

    def handle(self, *args, **kwargs):
        shackannotations = annotations.from_turk(kwargs['input'])
        with open(kwargs['output'], 'w') as outfile:
            json.dump(shackannotations, outfile, indent=2, sort_keys=True)
