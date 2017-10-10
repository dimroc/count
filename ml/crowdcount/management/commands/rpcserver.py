from crowdcount.ml.predictor import DEFAULT_VERSION
from django.core.management.base import BaseCommand
import crowdcount.rpc.server as rpcserver


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--mlversion', type=int, default=DEFAULT_VERSION)

    def handle(self, *args, **kwargs):
        version = kwargs['mlversion']
        port = rpcserver.port_for(version)
        print("Starting ML v{} gRPC server on port {}".format(version, port))
        rpcserver.serve(version)
