### redoing the 2025 lecture except: using opentimeseries...

library(opentimeseries)

baro <- read_open_ts(series = "idx", remote_archive = "opentsi/ch.kof.barometer")
baro_start <- as.integer(format(min(baro$date), c("%Y", "%m")))

plot <- stats::ts.plot(
  ts(baro$value, start = baro_start, frequency = 12),
  gpars = list(
    xlab = "Year",
    ylab = "Value",
    main = "KOF Economic Barometer"
  )
)
plot

# check which ts are available: 

datasets <- list_archives()
datasets
# works well, could use this for the example...

# lets try getting the tourism ts with excel
library(readxl)
library(tidyr)

trsm <- read_xlsx("examples/kof_ch.kof.trsm.fcst.year_ts_2026-10-10_17_41_56.xlsx") 

# subset only the column that includes the series we want
total <- trsm[, c("date", "ch.kof.trsm.fcst.ty.l.all.ch.lg")]
names(total) <- c("Date", "Overnight_Stays") # rename cols

# convert overnight stays to num and date to date
total$Overnight_Stays <- as.numeric(total$Overnight_Stays)
total$Date <- as.Date(total$Date)

head(total, n = 10)
