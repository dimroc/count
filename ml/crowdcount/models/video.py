from PIL import Image
from crowdcount.ml import CMAP
from crowdcount.models import paths as ccp
import cv2
import io
import matplotlib.pyplot as plt
import numpy as np


def create_side_by_side(p, images, output, video_shape, draw_position):
    # Define the codec and create VideoWriter object
    fourcc = cv2.VideoWriter_fourcc(*'mp4v')
    fps = 5.0
    out = cv2.VideoWriter(output, fourcc, fps, video_shape)

    for image in images:
        original_frame = cv2.imread(ccp.datapath(image))
        prediction = p.predict_crowd(original_frame)
        prediction_frame = get_prediction_frame(prediction, original_frame)
        combined = np.concatenate((original_frame, prediction_frame), axis=1)
        scaled = cv2.resize(combined, video_shape)
        drawn = draw_count(prediction, scaled, draw_position)
        out.write(drawn)
        cv2.imshow('video', drawn)
        if (cv2.waitKey(1) & 0xFF) == ord('q'):  # Hit `q` to exit
            break

    # Release everything if job is finished
    out.release()
    cv2.destroyAllWindows()


def draw_count(prediction, frame, position):
    cv2.putText(
        frame,
        str(int(round(prediction.crowd))),
        position,
        cv2.FONT_HERSHEY_SIMPLEX,
        0.5,
        (0, 0, 0),
        1,
        cv2.LINE_AA)
    return frame


def get_prediction_frame(prediction, image):
    height, width = image.shape[:2]
    img = _encode_image(prediction.density)
    rgb = np.array(img)[..., ::-1]  # Matplotlib is bgr, swap to rgb
    return cv2.resize(rgb, (width, height), interpolation=cv2.INTER_CUBIC)


def _encode_image(density):
    buf = io.BytesIO()
    plt.imsave(buf, density, cmap=CMAP, format='png')
    buf.seek(0)
    return Image.open(buf).convert("RGB")
