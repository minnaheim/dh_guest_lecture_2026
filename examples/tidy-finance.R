# build API diagrams using tidyfinance
library(pak)
pak::pkg_install("tidy-finance/r-tidyfinance")
library(tidyfinance)

# check which domain to put
?download_data

ubs <- download_data(
  domain = "Stock Prices",
  symbols = "UBS",
  start_date = "2024-01-01",
  end_date = "2025-12-31"
)
head(ubs)


# under the hood
# to check the final GET request: 
httr2::last_request()$url


# base url: "https://query2.finance.yahoo.com/"
# endpoint: "v8/finance/chart/{symbols}"
# path params: {symbols}
# query params: ?period1, ?period2, interval
# check that it works

"https://query2.finance.yahoo.com/v8/finance/chart/UBS?period1=1703894400&period2=1767312000&interval=1d"