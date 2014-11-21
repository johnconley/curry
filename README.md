CS74: Predicting basketball statistics

Dependencies
------------
- MATLAB R2014a
- [scrapy](http://scrapy.org/)
    * Run `pip install scrapy` to install


Instructions
------------
- To scrape, you must first set up the python environment by running in the home directory `source env/bin/activate`. Then run `scrapy crawl curry` in the `scraper/scraper` directory to crawl basketball-reference.com for data.


Data
----
- All data is contained in the `data` directory. The data was all collected from basketball-reference.com. We used total and per-possession data from the 1979-80 season, when the three-point line was introduced, to the present. `column_headers` gives a short description of each column of information.
