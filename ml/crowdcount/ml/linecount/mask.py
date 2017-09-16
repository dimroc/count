import cv2


_mask = cv2.imread("data/shakecam_line_mask.png", 0) // 255


def predict(x):
    assert _mask.shape == x.shape, "mask {} does not match input {}".format(_mask.shape, x.shape)
    return (_mask * x).sum()
