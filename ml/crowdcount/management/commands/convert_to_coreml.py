import os
import coremltools
from crowdcount.models import paths as ccp
from django.core.management.base import BaseCommand
from keras.engine import InputLayer
from keras.models import load_model


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--mlversion', default=2)
        parser.add_argument("-o", "--output", required=False, default='tmp/CrowdPredictor.mlmodel', help="output coreml file")

    def handle(self, *args, **kwargs):
        os.makedirs("tmp", exist_ok=True)

        version = kwargs['mlversion']
        path = ccp.weights_for("density", version)
        output = kwargs['output']
        print("Converting {0} to {1}".format(path, output))

        model = load_model(path)

        # Create a new input layer to replace the (None,None,3) input layer
        input_layer = InputLayer(input_shape=(675, 900, 3), name="input_1")

        # Save
        intermediary_path = "tmp/reshaped_model.h5"
        model.layers[0] = input_layer
        model.save(intermediary_path)

        # Convert
        coreml_model = coremltools.converters.keras.convert(
            intermediary_path,
            input_names=['input_1'],
            image_input_names=['input_1'],
            output_names=['density_map'])

        # Set model metadata
        coreml_model.author = 'Dimitri Roche'
        coreml_model.short_description = 'Generates a density map with the crowd estimate as the sum of pixels'
        coreml_model.input_description['input_1'] = 'Image to calculate density map'
        coreml_model.output_description['density_map'] = 'Density map where the sum of pixels is crowd count'

        coreml_model.save(output)
