from crowdcount.models import previewer
from crowdcount.models.annotations import annotations
from django.core.management.base import BaseCommand
import json


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--input', type=str, required=True)
        parser.add_argument('--output', type=str, default='data/annotations/shakecam.json')
        parser.add_argument('--save', action='store_true', default=False)

    def handle(self, *args, **kwargs):
        shackannotations = annotations.from_turk(kwargs['input'])
        with open(kwargs['output'], 'w') as outfile:
            json.dump(shackannotations, outfile, indent=2, sort_keys=True)

        if kwargs['save']:
            annotations.reload()
            self._write_images_to_tmp(shackannotations)

    def _write_images_to_tmp(self, anns):
        p = previewer.get('shakecam')
        for k in anns.keys():
            p.save(p.index_from_path(k))
