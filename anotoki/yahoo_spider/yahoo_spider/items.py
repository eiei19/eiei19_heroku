# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy

class TopNewsItem(scrapy.Item):
    title = scrapy.Field()
    topic_link = scrapy.Field()
    text = scrapy.Field()
    detail_link = scrapy.Field()