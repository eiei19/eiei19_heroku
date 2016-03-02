# -*- coding: utf-8 -*-
import json
class YahooSpiderPipeline(object):
    def process_item(self, item, spider):
        return item

class S3JsonPipeline(object):
    @classmethod
    def from_crawler(cls, crawler):
        return cls(
            aws_access_key_id=crawler.settings.get('AWS_ACCESS_KEY_ID'),
            aws_secret_access_key=crawler.settings.get('AWS_SECRET_ACCESS_KEY'),
            json_store=crawler.settings.get('JSON_STORE')
        )

    def __init__(self, aws_access_key_id, aws_secret_access_key, json_store):
        from boto.s3.connection import S3Connection
        self.S3Connection = S3Connection(aws_access_key_id, aws_secret_access_key, is_secure=False)
        self.bucket, self.prefix = json_store[5:].split('/', 1)

    def process_item(self, item, spider):
        bucket = self.S3Connection.get_bucket(self.bucket, validate=False)
        y,m,d = item["parsed_at"].split(" ")[0].split("/")
        key_name = '%s/%s/%s/%s/%s.json' % (self.prefix, y, m, d, item["id"])
        key = bucket.new_key(key_name)
        key.set_contents_from_string(json.dumps(dict(item), ensure_ascii=False))
        return item