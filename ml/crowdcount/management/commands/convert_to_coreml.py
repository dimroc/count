import coremltools
from crowdcount.models import paths as ccp
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--mlversion', default=2)
        parser.add_argument("-o", "--output", required=False, default='tmp/crowdcount.mlmodel', help="output coreml file")

    def handle(self, *args, **kwargs):
        version = kwargs['mlversion']
        path = ccp.weights_for("density", version)
        output = kwargs['output']
        print("Converting {0} to {1}".format(path, output))
        coreml_model = coremltools.converters.keras.convert(path)
        coreml_model.save(output)
