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
- To run pre-selected MARS regressions, call `run_mars` from the `mars` directory.  This script tests the MARS algorithm on per-possession data to predict two-point percentage, assists, total rebounds, and points for various positions.
- Call `interface` in the `mars` directory and follow the given directions to test MARS on parameters of your choosing.

GBDT
----
- To see how GBDT works, call `run_gbdt` from the `gbdt` directory. This script will run the GBDT algorithm on per-possession data and predict two-point percentage.

External Code
-------------
- All files in the `env` directory are from [virtualenv](https://virtualenv.pypa.io/en/latest/). All files in the `scraper` directory, with the exception of items.py and bballspider.py, are from scrapy.
