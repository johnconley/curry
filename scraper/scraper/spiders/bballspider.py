import scrapy


class CurrySpider(scrapy.Spider):
    name = "curry"
    allowed_domains = ["http://www.basketball-reference.com/"]
    start_urls = []
    with open("spiders/players", 'r') as f:
        [start_urls.append("http://www.basketball-reference.com" + line) for line in f]
    start_urls = start_urls[:10]

    def parse(self, response):
        filename = 'stats'
        player_stats = response.xpath('//tr[@class="full_table"]/td/text()').extract()
        with open(filename, 'a') as f:
            [f.write(data) for data in player_stats]
            f.write("\n")