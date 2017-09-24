from django.core.management.base import BaseCommand
import crowdcount.rpc.server as rpcserver


class Command(BaseCommand):
    def handle(self, *args, **kwargs):
        print("Starting ML gRPC server on port {}".format(rpcserver.DEFAULT_PORT))
        rpcserver.serve()
