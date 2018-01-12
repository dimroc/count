from crowdcount.ml import predictor
from crowdcount.models import paths as ccp
from django.core.management.base import BaseCommand
import cv2


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--mlversion', default=2)
        parser.add_argument("-o", "--output", required=False, default='tmp/output.mp4', help="output video file")

    def handle(self, *args, **kwargs):
        p = predictor.create(kwargs['mlversion'])
        output = kwargs['output']

        mall_dataset = ccp.get("mall")
        images = [mall_dataset.key_for(i) for i in range(1, 2001)]

        # Determine the width and height from the first image
        frame = cv2.imread(images[0])
        cv2.imshow('video', frame)
        height, width, channels = frame.shape

        # Define the codec and create VideoWriter object
        fourcc = cv2.VideoWriter_fourcc(*'mp4v')
        fps = 5.0
        out = cv2.VideoWriter(output, fourcc, fps, (width, height))

        for image in images:
            frame = cv2.imread(image)
            out.write(frame)
            cv2.imshow('video', frame)
            if (cv2.waitKey(1) & 0xFF) == ord('q'):  # Hit `q` to exit
                break

        # Release everything if job is finished
        out.release()
        cv2.destroyAllWindows()

        print("The output video is {}".format(output))
