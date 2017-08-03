#!/usr/bin/env python

from contextlib import contextmanager
from os import makedirs
from os.path import basename, dirname, isdir
from time import time
import boto3
import requests
import sys

@contextmanager
def fetch_image(source):
    r = requests.get(source)
    response = requests.get(source, stream=True)

    # Throw an error for bad status codes
    response.raise_for_status()
    yield response.content

def upload(data, key):
    print("Uploading {}...".format(key))
    s3 = boto3.resource('s3')
    s3.Bucket('dev.counting-company.com').put_object(Key=key, Body=data)

_now = int(time())
_source = "https://cdn.shakeshack.com/camera.jpg?{}".format(_now)
_destination = sys.argv[1] if len(sys.argv) > 1 else "tmp/shakeshack-{}.jpg".format(_now)

with fetch_image(_source) as data:
    upload(data, "shakeshack/{}".format(basename(_destination)))
