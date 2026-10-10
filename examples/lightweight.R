
library(jsonlite)
search_countries <- function(keyword){
    # note how URLencode improves this function
    # because spaces are common in searches
    # but are not allowed in URLs
    url <- sprintf("https://restcountries.com/v3.1/name/%s",
                   keyword)
    fromJSON(url)
}

View(search_countries("switzerland"))


