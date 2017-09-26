from PIL import Image
from concurrent import futures
from crowdcount.ml.predictor import Predictor
import attr
import crowdcount.rpc.ml_pb2 as ml_pb2
import crowdcount.rpc.ml_pb2_grpc as ml_pb2_grpc
import grpc
import io
import tensorflow as tf
import time

_ONE_DAY_IN_SECONDS = 60 * 60 * 24
DEFAULT_PORT = 50051

# Keras models aren't thread safe, so explicitly use graph.
# https://github.com/fchollet/keras/issues/5896
graph = tf.get_default_graph()
_predictor = Predictor()


@attr.s
class RPCServer(ml_pb2_grpc.RPCServicer):
    def CountCrowd(self, request, context):
        with graph.as_default():
            image = self._decode_image(request.image)
            prediction = _predictor.predict(image)
            print("Prediction: {}".format(prediction))
            return ml_pb2.CountCrowdReply(version="1",
                                          density_map=prediction.density.tobytes(),
                                          crowd_count=prediction.crowd,
                                          line_count=prediction.line)

    def _decode_image(self, image_str):
        image = Image.open(io.BytesIO(image_str))
        return image.convert('RGB')


def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=1))  # Wait for keras to become thread safe.
    ml_pb2_grpc.add_RPCServicer_to_server(RPCServer(), server)
    server.add_insecure_port("[::]:{}".format(DEFAULT_PORT))
    server.start()
    try:
        while True:
            time.sleep(_ONE_DAY_IN_SECONDS)
    except KeyboardInterrupt:
        server.stop(0)
