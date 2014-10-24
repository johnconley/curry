import scrapy

class CurrySpider(scrapy.Spider):
    name = "curry"
    allowed_domains = ["http://www.basketball-reference.com/"]
    start_urls = []
    with open("spiders/players", 'r') as f:
        for line in f.readlines():
            s = "http://www.basketball-reference.com" + line
            s = s[:-1]
            start_urls.append(s) 
    start_urls = start_urls[:10]
    print start_urls
    


    def parse(self, response):
        filename = "stats"
        player_stats = response.xpath('//tr[@class="full_table"]/td/text()').extract()
        print player_stats
        with open(filename, 'a') as f:
            for data in player_stats:
                f.write(data + ",")
            f.write("\n")

    
