## for our economic index, see how covid 19 cases affected economic activity (in switzerland)
rm(list = ls())

library(httr2)



## Step 1: get covid case counts over all time for a country 

get_case_counts <- function(country = "CH", period = c(30,365, "all")){
  # "https://disease.sh/v3/covid-19/historical/CH?lastdays=30"
  # this way is error prone, try to match.args to check if the inputs are correct
  base_url <- "https://disease.sh/v3/covid-19/historical"
  final_url <- paste0(base_url, "/", country, "?lastdays=", period)

  # perform API call with httr2
  req <- request(final_url) 
  resp <- req_perform(req)

  # if request is not successful
  if (resp_status(resp) != 200){
    message("The request was not successful")
  }
  else{
    return(resp_body_json(resp))
  }
}

get_case_counts("AUT", "all")

## Step 2: get vaccine rates

get_country_vaccine_rates <- function(country = "CH", period = c(30,365, "all")){
  # https://disease.sh/v3/covid-19/vaccine/coverage/countries/CH?lastdays=30&fullData=false
  # this way is error prone, try to match.args to check if the inputs are correct
  base_url <- "https://disease.sh/v3/covid-19/vaccine/coverage/countries"
  final_url <- paste0(base_url, "/", country, "?lastdays=", period, "&fullData=false")

  # perform  API call with httr2
  req <- request(final_url) 
  resp <- req_perform(req)

  # if request is not successful
  if (resp_status(resp) != 200)){
    message("The request was not successful")
  }
  else{
    return(resp_body_json(resp))
  }

}

get_country_vaccine_rates("CH", 30)


## ------------------- Chat

library(httr2)
library(jsonlite)

#' Get COVID-19 historical data from disease.sh API
#'
#' @param country A string for the country name or ISO code (e.g. "USA", "Canada").
#' @param lastdays Number of days of data to retrieve (default: "all").
#' @param province Optional; for countries with province-level data.
#' @param simplify If TRUE, convert JSON to data frame where possible.
#'
#' @return A list (or data frame) with COVID-19 historical data.
#' @examples
#' get_covid19_history("USA", lastdays = 30)
#' get_covid19_history("Canada", province = "Ontario")
get_covid19_history <- function(country,
                                lastdays = "all",
                                province = NULL,
                                simplify = TRUE) {
  # final URL: https://disease.sh/v3/covid-19/historical/CH?lastdays=4
  
  base_url <- "https://disease.sh/v3/covid-19/historical"
  
  req <- request(base_url) |>
    req_url_path_append(country) |>
    req_url_query(lastdays = lastdays)

  print(req)
  
  if (!is.null(province)) {
    req <- req_url_query(req, province = province)
  }
  
  # Send the request
  resp <- req |>
    req_perform()
  
  # Check for errors
  resp |>
    resp_check_status()
  
  # Parse response
  data <- resp_body_json(resp, simplifyVector = simplify)
  
  return(data)
}

get_covid19_history("CH", 4)


## -------------------- updated example:

library(httr2)

get_case_counts <- function(country = "CH", period = c(30,365, "all")){
  # "https://disease.sh/v3/covid-19/historical/CH?lastdays=30"
  # this way is error prone, try to match.args to check if the inputs are correct
  base_url <- "https://disease.sh/v3/covid-19/historical"
  # final_url <- paste0(base_url, "/", country, "?lastdays=", period)

  # alternative - using 
  req <- request(base_url) %>%
    req_url_path_append(country) %>%
    req_url_query(period = period)

  # perform API call with httr2
  # req <- request(final_url)
  print(req) 
  resp <- req_perform(req)

  # if request is not successful
  if (resp_status(resp) != 200){
    message("The request was not successful")
  }
  else{
    return(resp_body_json(resp))
  }
}

get_case_counts("CH", 5)
