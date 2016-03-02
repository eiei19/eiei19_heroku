# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy

class TopNewsItem(scrapy.Item):
    id = scrapy.Field()
    category = scrapy.Field()
    posted_at = scrapy.Field()
    title = scrapy.Field()
    topic_link = scrapy.Field()
    text = scrapy.Field()
    detail_link = scrapy.Field()
    parsed_at = scrapy.Field()