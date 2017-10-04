from crowdcount.ml.prediction import Prediction
from crowdcount.ml.predictor import Predictor, DEFAULT_WEIGHTS
from crowdcount.models import paths as ccp, previewer as pwr, annotations as ants
from django.core.management.base import BaseCommand
from random import sample
import crowdcount.ml as ml
import os


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--image', default=None)
        parser.add_argument('--weights', default=DEFAULT_WEIGHTS)
        parser.add_argument('--save', action='store_true', default=False)
        parser.add_argument('--just-predictions', action='store_true', default=False)
        parser.add_argument('--only-linecounts', action='store_true', default=False)

    def handle(self, *args, **kwargs):
        images = kwargs['image']
        if not kwargs['image']:
            train, test = ants.groundtruth.train_test_split(kwargs['only_linecounts'])
            images = sample(train + test, len(train) + len(test))
        else:
            images = [kwargs['image']]

        self.predictor = Predictor(kwargs['weights'])
        self.previewer = pwr.Previewer(just_predictions=kwargs['just_predictions'])
        self._predict_images(images, kwargs['save'])

    def _predict_images(self, images, save=False):
        for image in images:
            prediction = self.predictor.predict_line(ml.load_img(image))
            truth = self._get_truth(image)
            if save:
                dest = ccp.output("predictions/{}".format(os.path.basename(image)))
                self.previewer.save(dest, image, prediction, truth)
            else:
                if self.previewer.show(image, prediction, truth) == 'n':
                    break

    def _get_truth(self, path):
        if "data/shakecam" in path:
            return self.predictor.predict_line_from_truth(path)
        else:
            return Prediction()
