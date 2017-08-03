#!/usr/bin/env python

import boto3
import datetime

s3 = boto3.resource('s3')
bucket_name = 'dev.counting-company.com'
bucket = s3.Bucket(bucket_name)
bucket_location = boto3.client('s3').get_bucket_location(Bucket=bucket_name)

def public_url(s3object):
    return "https://s3.amazonaws.com/{0}/{1}".format(
            bucket_name,
            s3object.key)

def useful_time(entry):
    t = datetime.datetime.fromtimestamp(int(entry.key[22:-4]))
    return t.hour > 9 and entry.size > 0


for entry in bucket.objects.filter(Prefix='shakeshack'):
    if useful_time(entry): print(public_url(entry))
