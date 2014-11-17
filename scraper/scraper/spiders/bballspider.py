import scrapy
from scrapy.contrib.loader import ItemLoader
from scraper.items import Player

class CurrySpider(scrapy.Spider):
    # initialize spider
    name = "curry"
    allowed_domains = ["http://www.basketball-reference.com/"]
    start_urls = []
    with open("players", 'r') as f:
        # add all player URLs
        for line in f.readlines():
            s = "http://www.basketball-reference.com" + line
            s = s[:-1]
            start_urls.append(s)

    # start_urls = start_urls[:10]

    def parse(self, response):
        filename = "stats_totals"
        player_id = response.url.split("/")[-1].split(".")[0]
        name = response.xpath('//div[@id="info_box"]//h1/text()').extract()[0]
        table = '//table[@id="totals"]/tbody'
        rows = response.xpath(table).css('tr')
        fields = ['id',
                  'name',
                  'season',
                  'age',
                  'team',
                  'league',
                  'position',
                  'games',
                  'games_started',
                  'minutes_played',
                  'field_goals',
                  'field_goal_attempts',
                  'field_goal_percentage',
                  'three_point_fg',
                  'three_point_fga',
                  'three_point_fgp',
                  'two_point_fg',
                  'two_point_fga',
                  'two_point_fgp',
                  'free_throws',
                  'free_throw_attempts',
                  'free_throw_percentage',
                  'off_rebounds',
                  'def_rebounds',
                  'tot_rebounds',
                  'assists',
                  'steals',
                  'blocks',
                  'turnovers',
                  'fouls',
                  'points']
        scraping_fields = fields[2:]

        player_stats = []
        for row in rows:
            l = ItemLoader(item=Player(), response=response)
            l.add_value('id', player_id)
            l.add_value('name', name)

            for j, f in enumerate(scraping_fields):
                # get text in ith row, jth column of the table
                val = row.css('td')[j].xpath('text()').extract()
                if len(val) < 1:
                    val = row.css('td')[j].xpath('a/text()').extract()

                # add value to the ItemLoader
                if len(val) < 1:
                    l.add_value(f, '')
                else:
                    l.add_value(f, val[0])

            player_stats.append(l.load_item())

        with open(filename, 'a') as f:
            for item in player_stats:
                # get the value of the fields for each individual item
                vals = [item[field][0] for field in fields]
                f.write(','.join(vals))
                f.write('\n')
