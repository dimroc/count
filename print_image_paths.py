#!/usr/bin/env python

import boto3
import datetime
import pytz
import time

s3 = boto3.resource('s3')
bucket_name = 'dev.counting-company.com'
bucket = s3.Bucket(bucket_name)
bucket_location = boto3.client('s3').get_bucket_location(Bucket=bucket_name)
eastern = pytz.timezone('US/Eastern')
last_turk = 1501891200


def public_url(s3object):
    return "https://s3.amazonaws.com/{0}/{1}".format(
            bucket_name,
            s3object.key)


def useful_time(entry):
    t = datetime.datetime.fromtimestamp(int(entry.key[22:-4]), eastern)
    # After August 4th and only images after 7 AM
    return t.hour > 7 and entry.size > 0 \
        and time.mktime(t.timetuple()) >= last_turk


for entry in bucket.objects.filter(Prefix='shakeshack'):
    if useful_time(entry):
        print(public_url(entry))
