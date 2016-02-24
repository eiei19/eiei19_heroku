# -*- coding: utf-8 -*-
import scrapy
import re
from yahoo_spider.items import TopNewsItem

class TopNewsSpider(scrapy.Spider):
    name = "top_news"
    allowed_domains = ["news.yahoo.co.jp"]

    def __init__(self, prefecture=None, *args, **kwargs):
        self.start_urls = [
            'http://news.yahoo.co.jp/',
            'http://news.yahoo.co.jp/hl?c=bus'
        ]

    def parse(self, response):
        for li in response.xpath('//ul[@class="topics"]/li[not(@class)]'):
            print li.xpath('.//a/text()').extract_first()