import crowdcount.ml as ml
import pytest


def test_shakecam_line_prediction(predictor, shakecam_key):
    prediction = predictor.predict_line(ml.load_img(shakecam_key))
    assert prediction.line == pytest.approx(11, rel=4)
    assert prediction.crowd == pytest.approx(30, rel=4)


def test_mall_crowd_prediction(predictor, mall_key):
    prediction = predictor.predict_crowd(ml.load_img(mall_key))
    assert prediction.crowd == pytest.approx(22, rel=5)
    assert prediction.line is None
