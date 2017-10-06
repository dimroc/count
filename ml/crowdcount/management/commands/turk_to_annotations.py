from crowdcount.models import previewer, annotations as ants, paths as ccp
from django.core.management.base import BaseCommand
import csv
import json
import os


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--input', type=str, default=ccp.datapath('data/mturk/cropped_heads.results.csv'))
        parser.add_argument('--ignorables', type=str, default=ccp.datapath('data/mturk/cropped_heads.ignorables.csv'))
        parser.add_argument('--output', type=str, default=ccp.datapath('data/annotations/shakecam.json'))
        parser.add_argument('--save', action='store_true', default=False)

    def handle(self, *args, **kwargs):
        annotations = ants.from_turk(kwargs['input'])
        annotations = self._exclude_ignorables(annotations, kwargs['ignorables'])
        with open(kwargs['output'], 'w') as outfile:
            json.dump(annotations, outfile, indent=2, sort_keys=True)

        if kwargs['save']:
            ants.groundtruth.reload()
            self._write_images_to_tmp(annotations)

    def _write_images_to_tmp(self, anns):
        os.makedirs(ccp.output("previews/"), exist_ok=True)
        for key in anns.keys():
            previewer.save(ccp.output("previews/{}.jpg".format(_index_from_key(key))), key)

    def _exclude_ignorables(self, annotations, ignorables_path):
        with open(ignorables_path) as csvfile:
            reader = csv.reader(csvfile)
            ignorables = [row[0] for row in reader]
        return {k: v for k, v in annotations.items() if k not in ignorables}


def _index_from_key(key):
    return key[-14:-4]
