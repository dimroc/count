from PIL import Image
from crowdcount.ml import predictor, CMAP
from crowdcount.models import paths as ccp
from django.core.management.base import BaseCommand
import cv2
import io
import matplotlib.pyplot as plt
import numpy as np


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
        videow, videoh = 800, 300

        # Define the codec and create VideoWriter object
        fourcc = cv2.VideoWriter_fourcc(*'mp4v')
        fps = 5.0
        out = cv2.VideoWriter(output, fourcc, fps, (videow, videoh))

        for image in images:
            original_frame = cv2.imread(image)
            prediction_frame = get_prediction_frame(p, original_frame)
            combined = np.concatenate((original_frame, prediction_frame), axis=1)

            scaled = cv2.resize(combined, (videow, videoh))
            out.write(scaled)
            cv2.imshow('video', scaled)
            if (cv2.waitKey(1) & 0xFF) == ord('q'):  # Hit `q` to exit
                break

        # Release everything if job is finished
        out.release()
        cv2.destroyAllWindows()

        print("The output video is {}".format(output))


def get_prediction_frame(p, image):
    height, width = image.shape[:2]
    prediction = p.predict_crowd(image)
    img = _encode_image(prediction.density)
    rgb = np.array(img)[..., ::-1]  # Matplotlib is bgr, swap to rgb
    return cv2.resize(rgb, (width, height), interpolation=cv2.INTER_CUBIC)


def _encode_image(density):
    buf = io.BytesIO()
    plt.imsave(buf, density, cmap=CMAP, format='png')
    buf.seek(0)
    return Image.open(buf).convert("RGB")
