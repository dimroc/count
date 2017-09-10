from contextlib import contextmanager
from django.core.management.base import BaseCommand
from os.path import basename
from time import time
import boto3
import crowdcount.models.paths as ccp
import requests


class Command(BaseCommand):
    def handle(self, *args, **kwargs):
        now = int(time())
        source = "https://cdn.shakeshack.com/camera.jpg?{}".format(now)
        destination = ccp.output("shakeshack-{}.jpg".format(now))

        with _fetch_image(source) as data:
            if len(data) > 0:
                _upload(data, "shakeshack/{}".format(basename(destination)))


@contextmanager
def _fetch_image(source):
    response = requests.get(source, stream=True)

    # Throw an error for bad status codes
    response.raise_for_status()
    yield response.content


def _upload(data, key):
    print("Uploading {}...".format(key))
    s3 = boto3.resource('s3')
    s3.Bucket('dev.counting-company.com').put_object(Key=key, Body=data)
