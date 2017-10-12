from crowdcount.ml.prediction import Prediction
from crowdcount.ml import predictor
from crowdcount.models import paths as ccp, previewer as pwr, annotations as ants
from django.core.management.base import BaseCommand
from random import sample
import crowdcount.ml as ml
import os


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--image', default=None)
        parser.add_argument('--mlversion', default=2)
        parser.add_argument('--save', action='store_true', default=False)
        parser.add_argument('--just-predictions', action='store_true', default=False)
        parser.add_argument('--only-linecounts', action='store_true', default=False)

    def handle(self, *args, **kwargs):
        image_keys = kwargs['image']
        if not kwargs['image']:
            train, test = ants.groundtruth.train_test_split(kwargs['only_linecounts'])
            image_keys = sample(train + test, len(train) + len(test))
        else:
            image_keys = [kwargs['image']]

        self.predictor = predictor.create(kwargs['mlversion'])
        self.previewer = pwr.Previewer(just_predictions=kwargs['just_predictions'])
        self._predict_images(image_keys, kwargs['save'])

    def _predict_images(self, image_keys, save=False):
        for image_key in image_keys:
            prediction = self.predictor.predict_line(ml.load_img(image_key))
            truth = self._get_truth(image_key)
            if save:
                dest = ccp.output("predictions/{}".format(os.path.basename(image_key)))
                self.previewer.save(dest, image_key, prediction, truth)
            else:
                self.previewer.show(image_key, prediction, truth)
                if input("Continue? [y]/n: ") == 'n':
                    break

    def _get_truth(self, image_key):
        if "data/shakecam" in image_key:
            return self.predictor.predict_line_from_truth(image_key)
        else:
            return Prediction()
