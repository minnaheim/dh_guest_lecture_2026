library(plumber)

###### ------ prep start 
library(opentimeseries)
baro <- read_open_ts(
  series = "idx",
  remote_archive = "opentsi/ch.kof.barometer"
)
baro_start <- as.integer(format(min(baro$date), c("%Y", "%m")))
data <- list(kofbarometer = ts(baro$value, start = baro_start, frequency = 12))
# str(data$kofbarometer)
partition_ts <- function(ts, start = NULL, end = NULL){
  if(inherits(ts, "ts")){
    # setting start and end date if unset
    if(is.null(end)){
      end <- time(ts)[length(ts)]
    }
    if (is.null(start)){
      start <- time(ts)[1]
    }
    # filter ts based on start & end dates
    ts <- window(ts, start = start, end = end)
  }
  else {
    warning("Input is not a ts object")
    return(NULL)
  }
  return(ts)
}

###### ------ prep end

#* get entire time series data
#* @get /data
function(){
  # list(msg = paste0("does this work?"))
  partition_ts(data$kofbarometer)
}


#* return data w/ start and end dates.
#* @param start the start year to filter by
#* @param end the end year to filter by
#* @get /filtered_data

function(start=NULL, end=NULL){
  if(!is.null(start)){
    start <- as.numeric(start)
  }
  if(!is.null(end)){
    end <- as.numeric(end)
  } 
  
  partition_ts(
    data$kofbarometer,
    start = start,
    end = end
  )
}



#* return a plot of the entire ts
#* @serializer png
#* @get /plotting
function(){
  plot(data$kofbarometer)
}


# run in console
# hint: the plumber file needs to be at the base of your working directory
# pr("examples/plumber.R") %>%
#   pr_run(port=8000)