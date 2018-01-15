from crowdcount.ml import predictor
from crowdcount.models import paths as ccp, video
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--mlversion', default=2)
        parser.add_argument("-o", "--output", required=False, default='tmp/mall.mp4', help="output video file")

    def handle(self, *args, **kwargs):
        p = predictor.create(kwargs['mlversion'])
        output = kwargs['output']

        mall_dataset = ccp.get("mall")
        images = [mall_dataset.key_for(i) for i in range(1, 2001)]

        video.create_side_by_side(p, images, output, (800, 300), (800 - 30, 20))
        print("The output video is {}".format(output))
