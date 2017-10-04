from PIL import Image
from concurrent import futures
from crowdcount.ml.predictor import Predictor
import attr
import crowdcount.rpc.ml_pb2 as ml_pb2
import crowdcount.rpc.ml_pb2_grpc as ml_pb2_grpc
import grpc
import io
import matplotlib.pyplot as plt
import tensorflow as tf
import time

_ONE_DAY_IN_SECONDS = 60 * 60 * 24
DEFAULT_PORT = 50051

# Keras models aren't thread safe, so explicitly use graph.
# https://github.com/fchollet/keras/issues/5896
graph = tf.get_default_graph()
_predictor = Predictor()


def predict_crowd(image_str):
    return _predict(image_str, _predictor.predict_crowd)


def predict_line(image_str):
    return _predict(image_str, _predictor.predict_line)


def _predict(image_str, method):
    with graph.as_default():
        image = _decode_image(image_str)
        prediction = method(image)
        print("Prediction: {}".format(prediction))
        return ml_pb2.CountReply(version="1",
                density_map=_encode_image(prediction.density),
                crowd_count=prediction.crowd,
                line_count=prediction.line)


def _decode_image(image_str):
    return Image.open(io.BytesIO(image_str)).convert('RGB')


def _encode_image(density):
    buf = io.BytesIO()
    plt.imsave(buf, density, cmap='seismic', format='png')
    buf.seek(0)
    final = io.BytesIO()
    Image.open(buf).convert("RGB").save(final, 'JPEG', quality=100)
    return final.getvalue()


@attr.s
class RPCServer(ml_pb2_grpc.RPCServicer):
    def CountCrowd(self, request, context):
        return predict_crowd(request.image)

    def CountLine(self, request, context):
        return predict_line(request.image)


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
