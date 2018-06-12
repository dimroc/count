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
        coreml_model = coremltools.converters.keras.convert(
            path,
            input_names='image',
            output_names='density_map')

        # Set model metadata
        coreml_model.author = 'Dimitri Roche'
        coreml_model.short_description = 'Generates a density map with crowd estimate.'
        coreml_model.input_description['image'] = 'Image to calculate density map'
        coreml_model.output_description['density_map'] = 'Density map where the sum of pixels is crowd count'

        coreml_model.save(output)
