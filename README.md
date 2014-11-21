CS74: Predicting basketball statistics

Dependencies
------------
- MATLAB R2014a
- [scrapy](http://scrapy.org/)
    * Run `pip install scrapy` to install


Data
----
- All data is contained in the `data` directory. The data was all collected from basketball-reference.com. We used total and per-possession data from the 1979-80 season, when the three-point line was introduced, to the present. `column_headers` gives a short description of each column of information.
- To scrape your own data, you must first set up the python environment by running in the home directory `source env/bin/activate`. Then run `scrapy crawl curry` in the `scraper/scraper` directory to crawl basketball-reference.com for data.

MARS
----

GBDT
----
- To see how GBDT works, call `run_gbdt` from the `gbdt` directory. This script will run the GBDT algorithm on per-possession data and predict two-point percentage.
