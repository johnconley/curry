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


    # remove when appropriate
    start_urls = start_urls[:1]
    print start_urls

    def parse(self, response):
        filename = "stats"
        player_id = response.url.split("/")[-1].split(".")[0]
        name = response.xpath('//div[@id="info_box"]/h1/text()').extract()[0]
        table = '//table[@id="per_minute"]/tbody'
        row = '/tr[@class="full_table"]'
        num_rows = len(response.xpath(table).css('tr').xpath('//td[1]'))

        def column(k):
            return table + row + '/td[' + str(k) + ']/text()'

        player_stats = []
        for i in range(num_rows ):
            l = ItemLoader(item=Player(), response=response)
            l.add_value('id', player_id)
            l.add_value('name', name)
            # l.add_xpath('season', )

            # add all fields here

            l.add_xpath('age', column(2))
            player_stats.append(l.load_item())

        with open(filename, 'a') as f:
            for item in player_stats:
                # this prints the fields in alphabetical order, not in the order we define them
                [f.write(data[1][0] + ',') for data in item.items()]
                f.write('\n')

        # print "num_rows = " + str(num_rows)
