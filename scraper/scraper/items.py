# -*- coding: utf-8 -*-

# Define here the models for your scraped items
#
# See documentation in:
# http://doc.scrapy.org/en/latest/topics/items.html

import scrapy


class Player(scrapy.Item):
    name = scrapy.Field()
    season = scrapy.Field()
    age = scrapy.Field()
    team = scrapy.Field()
    league = scrapy.Field()
    position = scrapy.Field()
    games = scrapy.Field()
    games_started = scrapy.Field()
    minutes_played = scrapy.Field()
    field_goals = scrapy.Field()
    field_goal_attempts = scrapy.Field()
    field_goal_percentage = scrapy.Field()
    three_point_fg = scrapy.Field()
    three_point_fga = scrapy.Field()
    three_point_fgp = scrapy.Field()
    two_point_fg = scrapy.Field()
    two_point_fga = scrapy.Field()
    two_point_fgp = scrapy.Field()
    free_throws = scrapy.Field()
    free_throw_attempts = scrapy.Field()
    free_throw_percentage = scrapy.Field()
    off_rebounds = scrapy.Field()
    def_rebounds = scrapy.Field()
    tot_rebounds = scrapy.Field()
    assists = scrapy.Field()
    steals = scrapy.Field()
    blocks = scrapy.Field()
    turnovers = scrapy.Field()
    fouls = scrapy.Field()
    points = scrapy.Field()
    pass
