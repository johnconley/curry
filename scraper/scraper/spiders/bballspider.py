import scrapy


class CurrySpider(scrapy.Spider):
    name = "curry"
    allowed_domains = ["http://www.basketball-reference.com/"]
    start_urls = ["http://www.basketball-reference.com/players/a",
    "http://www.basketball-reference.com/players/b",
    "http://www.basketball-reference.com/players/c",
    "http://www.basketball-reference.com/players/d",
    "http://www.basketball-reference.com/players/e",
    "http://www.basketball-reference.com/players/f",
    "http://www.basketball-reference.com/players/g",
    "http://www.basketball-reference.com/players/h",
    "http://www.basketball-reference.com/players/i",
    "http://www.basketball-reference.com/players/j",
    "http://www.basketball-reference.com/players/k",
    "http://www.basketball-reference.com/players/l",
    "http://www.basketball-reference.com/players/m",
    "http://www.basketball-reference.com/players/n",
    "http://www.basketball-reference.com/players/o",
    "http://www.basketball-reference.com/players/p",
    "http://www.basketball-reference.com/players/q",
    "http://www.basketball-reference.com/players/r",
    "http://www.basketball-reference.com/players/s",
    "http://www.basketball-reference.com/players/t",
    "http://www.basketball-reference.com/players/u",
    "http://www.basketball-reference.com/players/v",
    "http://www.basketball-reference.com/players/w",
    "http://www.basketball-reference.com/players/x",
    "http://www.basketball-reference.com/players/y",
    "http://www.basketball-reference.com/players/z"]

    def parse(self, response):
        filename = 'players'
        player_urls = response.xpath('//tr/td[1]/a/@href').extract()
        with open(filename, 'a') as f:
           	for p in player_urls:
           		f.write(p+"\n")