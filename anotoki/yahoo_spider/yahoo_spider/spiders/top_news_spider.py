# -*- coding: utf-8 -*-
import scrapy
import re
from yahoo_spider.items import TopNewsItem

class TopNewsSpider(scrapy.Spider):
    name = "top_news"
    allowed_domains = ["news.yahoo.co.jp"]

    def __init__(self, prefecture=None, *args, **kwargs):
        self.start_urls = ['http://news.yahoo.co.jp/topics']

    def parse(self, response):
        for li in response.xpath('//ul[@class="fl" or @class="fr"]/li[not(@class)]'):
            yield scrapy.Request(li.xpath('.//a/@href').extract_first(), callback=self.parse_detail)
            break

    def parse_detail(self, response):
        item = {}
        item['category'] = response.xpath('//ul[@id="gnSec"]/li[@class="current"]/a/text()').extract_first()
        item['posted_at'] = response.xpath('//div[@class="topicsName"]/span[@class="date"]/text()').extract_first()
        item['title'] = response.xpath('//h1/text()').extract_first()
        item['topic_link'] = response.url
        item['text'] = response.xpath('//p[@class="hbody"]/text()').extract_first()
        item['detail_link'] = response.xpath('//a[@class="newsLink"]/@href').extract_first()
        return item