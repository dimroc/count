import grpc
import time
import crowdcount.rpc.ml_pb2 as ml_pb2
import crowdcount.rpc.ml_pb2_grpc as ml_pb2_grpc
from concurrent import futures

_ONE_DAY_IN_SECONDS = 60 * 60 * 24
DEFAULT_PORT = 50051


class RPCServer(ml_pb2_grpc.RPCServicer):
    def CountCrowd(self, request, context):
        print("doing something with\n{}\n{}".format(request, context))
        return ml_pb2.CountCrowdReply(version="1",
                                      density_map=None,
                                      crowd_count=5,
                                      line_count=2)


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
