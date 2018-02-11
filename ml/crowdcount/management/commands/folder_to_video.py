from crowdcount.ml import predictor
from crowdcount.models import video
from django.core.management.base import BaseCommand
import fnmatch
import os


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--mlversion', default=2)
        parser.add_argument("-o", "--output", required=False, default='tmp/output.mp4', help="output video file")
        parser.add_argument("-i", "--input", required=True, help="input frames, lexigraphically sorted")

    def handle(self, *args, **kwargs):
        p = predictor.create(kwargs['mlversion'])
        output = kwargs['output']
        folder = kwargs['input']

        images = sorted([os.path.join(folder, path) for path in os.listdir(folder) if fnmatch.fnmatch(path, "*.jpg")])
        video.create_side_by_side(p, images, output, (800, 300), (400 + 10, 20))
        print("The output video is {}".format(output))
