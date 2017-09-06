import boto3
import datetime
import pytz
import time
from django.core.management.base import BaseCommand


class Command(BaseCommand):
    def add_arguments(self, parser):
        parser.add_argument('--origin', type=str, default='public')

    def handle(self, *args, **kwargs):
        getattr(self, kwargs['origin'])()

    def public(self):
        s3 = boto3.resource('s3')
        bucket_name = 'dimroc-public'
        bucket = s3.Bucket(bucket_name)

        for entry in bucket.objects.filter(Prefix='shakecam/shakeshack'):
            self.stdout.write(_s3_url(bucket_name, entry))

    def private(self):
        s3 = boto3.resource('s3')
        bucket_name = 'dev.counting-company.com'
        bucket = s3.Bucket(bucket_name)
        eastern = pytz.timezone('US/Eastern')
        last_turk = 1501891200
        current_cutoff = 1504710712

        def useful_time(entry):
            t = datetime.datetime.fromtimestamp(int(entry.key[22:-4]), eastern)
            now = time.mktime(t.timetuple())
            # Before Sept 6th at 11 and only images after 7 AM
            return t.hour > 7 and entry.size > 0 \
                and now < current_cutoff

        for entry in bucket.objects.filter(Prefix='shakeshack'):
            if useful_time(entry):
                self.stdout.write(_s3_url(bucket_name, entry))


def _s3_url(bucket_name, s3object):
    return "https://s3.amazonaws.com/{0}/{1}".format(bucket_name, s3object.key)
