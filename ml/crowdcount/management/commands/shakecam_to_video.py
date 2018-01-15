from crowdcount.ml import predictor
from crowdcount.models import paths as ccp, video
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--mlversion', default=2)
        parser.add_argument("-o", "--output", required=False, default='tmp/shakecam.mp4', help="output video file")
        parser.add_argument("-s", "--starting", required=False, default='1500828718', help="The frame to start the video at")
        parser.add_argument("-d", "--duration", required=False, default=1000, help="The number of frames to use in video")

    def handle(self, *args, **kwargs):
        p = predictor.create(kwargs['mlversion'])
        output = kwargs['output']
        starting = int(kwargs['starting'])
        duration = int(kwargs['duration'])

        dataset = ccp.get("shakecam")
        images = dataset.from_index(starting)[:duration]

        video.create_side_by_side(p, images, output, (800, 400), (400 + 10, 400 - 10))
        print("The output video is {}".format(output))
