from django.core.management.base import BaseCommand
import fnmatch
import os


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument("-i", "--input", required=True, help="input frames, lexigraphically sorted")

    def handle(self, *args, **kwargs):
        folder = kwargs['input']
        images = sorted([os.path.join(folder, path) for path in os.listdir(folder) if fnmatch.fnmatch(path, "*.jpg")])
        for image in images:
            if not fnmatch.fnmatch(image, "*0.jpg"):
                os.remove(image)
