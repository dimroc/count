import crowdcount.ml as ml
import pytest


def test_shakecam_line_prediction(predictor):
    image_key = "data/shakecam/shakeshack-1500920808.jpg"
    prediction = predictor.predict_line(ml.load_img(image_key))
    assert prediction.line == pytest.approx(11, rel=4)
    assert prediction.crowd == pytest.approx(30, rel=4)


def test_mall_crowd_prediction(predictor):
    image_key = "data/mall/frames/seq_000153.jpg"
    prediction = predictor.predict_crowd(ml.load_img(image_key))
    assert prediction.crowd == pytest.approx(22, rel=5)
    assert prediction.line is None
