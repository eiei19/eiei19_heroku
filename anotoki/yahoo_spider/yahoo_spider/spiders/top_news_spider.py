# -*- coding: utf-8 -*-
import scrapy
import re
import datetime
import yahoo_spider.jst
from yahoo_spider.items import TopNewsItem

class TopNewsSpider(scrapy.Spider):
    name = "top_news"
    allowed_domains = ["news.yahoo.co.jp"]

    def __init__(self, prefecture=None, *args, **kwargs):
        self.start_urls = [
            'http://news.yahoo.co.jp/',
            'http://news.yahoo.co.jp/hl?c=dom',
            'http://news.yahoo.co.jp/hl?c=c_int',
            'http://news.yahoo.co.jp/hl?c=bus',
            'http://news.yahoo.co.jp/hl?c=c_ent',
            'http://news.yahoo.co.jp/hl?c=c_spo',
            'http://news.yahoo.co.jp/hl?c=c_sci',
            'http://news.yahoo.co.jp/hl?c=loc'
        ]

    def parse(self, response):
        for li in response.xpath('//ul[@class="topics"]/li[not(@class) or @class!="topicsFt"]'):
            yield scrapy.Request(li.xpath('.//a/@href').extract_first(), callback=self.parse_detail)

    def parse_detail(self, response):
        item = TopNewsItem()
        if response.request.headers.get('Referer') == "http://news.yahoo.co.jp/":
            item['is_top'] = True
        else:
            item['is_top'] = False
        item['id'] = response.url.split("/")[-1]
        item['category'] = response.xpath('//ul[@id="gnSec"]/li[@class="current"]/a/text()').extract_first()
        item['posted_at'] = response.xpath('//div[@class="topicsName"]/span[@class="date"]/text()').extract_first()
        item['title'] = response.xpath('//h1/text()').extract_first()
        item['topic_link'] = response.url
        item['text'] = response.xpath('//p[@class="hbody"]/text()').extract_first()
        item['detail_link'] = response.xpath('//a[@class="newsLink"]/@href').extract_first()
        item['parsed_at'] = datetime.datetime.now(tz=JST()).strftime("%Y/%m/%d %H:%M:%S")
        return item

class JST(datetime.tzinfo):
  def utcoffset(self, dt):
    return datetime.timedelta(hours=9)

  def dst(self, dt):
    return datetime.timedelta(0)

  def tzname(self, dt):
    return 'JST'