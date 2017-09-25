from concurrent import futures
from crowdcount.ml.predictor import Predictor
import attr
import crowdcount.rpc.ml_pb2 as ml_pb2
import crowdcount.rpc.ml_pb2_grpc as ml_pb2_grpc
import cv2
import grpc
import numpy as np
import time

_ONE_DAY_IN_SECONDS = 60 * 60 * 24
DEFAULT_PORT = 50051


@attr.s
class RPCServer(ml_pb2_grpc.RPCServicer):
    predictor = attr.ib(default=attr.Factory(Predictor))

    def CountCrowd(self, request, context):
        image = self._decode_image(request.image)
        prediction = self.predictor.predict(image)
        return ml_pb2.CountCrowdReply(version="1",
                                      density_map=prediction.density,
                                      crowd_count=prediction.crowd,
                                      line_count=prediction.line)

    def _decode_image(self, image_str):
        image = np.fromstring(image_str, np.uint8)
        return cv2.imdecode(image, cv2.IMREAD_COLOR).reshape(720, 720, 3)


def serve():
    server = grpc.server(futures.ThreadPoolExecutor(max_workers=2))
    ml_pb2_grpc.add_RPCServicer_to_server(RPCServer(), server)
    server.add_insecure_port("[::]:{}".format(DEFAULT_PORT))
    server.start()
    try:
        while True:
            time.sleep(_ONE_DAY_IN_SECONDS)
    except KeyboardInterrupt:
        server.stop(0)
