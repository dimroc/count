from crowdcount.ml.predictor import Predictor
import pytest


@pytest.fixture(scope='module')
def predictor():
    return Predictor()
