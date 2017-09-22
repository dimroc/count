import crowdcount.models.paths as ccp
import cv2
import numpy as np


array = cv2.imread(ccp.datapath("data/shakecam_line_mask.png"), 0) // 255
batch_array = array[np.newaxis][..., None]


def predict(x):
    x = np.squeeze(x)
    assert array.shape == x.shape, "mask {} does not match input {}".format(array.shape, x.shape)
    return (array * x).sum()
