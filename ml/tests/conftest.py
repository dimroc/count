from crowdcount.ml.predictor import Predictor
from crowdcount.models import previewer as pwr
import pytest


@pytest.fixture(scope='module')
def predictor():
    return Predictor()


@pytest.fixture(scope='module')
def previewer():
    return pwr


@pytest.fixture
def shakecam_key():
    return "data/shakecam/shakeshack-1500920808.jpg"


@pytest.fixture
def mall_key():
    return "data/mall/frames/seq_000153.jpg"
