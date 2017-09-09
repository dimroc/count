from crowdcount.models import previewer, annotations as ants
from django.core.management.base import BaseCommand
import json
import os


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--input', type=str, required=True)
        parser.add_argument('--output', type=str, default='data/annotations/shakecam.json')
        parser.add_argument('--save', action='store_true', default=False)

    def handle(self, *args, **kwargs):
        annotations = ants.from_turk(kwargs['input'])
        with open(kwargs['output'], 'w') as outfile:
            json.dump(annotations, outfile, indent=2, sort_keys=True)

        if kwargs['save']:
            ants.groundtruth.reload()
            self._write_images_to_tmp(annotations)

    def _write_images_to_tmp(self, anns):
        os.makedirs("tmp/previews/", exist_ok=True)
        for path in anns.keys():
            previewer.save(path, "tmp/previews/{}.jpg".format(_index_from_path(path)))


def _index_from_path(path):
    return path[-14:-4]
