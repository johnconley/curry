import scrapy


class CurrySpider(scrapy.Spider):
    name = "curry"
    allowed_domains = ["http://www.basketball-reference.com/"]
    start_urls = ["http://www.basketball-reference.com/players/"]

    def parse(self, response):
        filename = response.url.split("/")[-2]
        with open(filename, 'wb') as f:
            f.write(response.body)