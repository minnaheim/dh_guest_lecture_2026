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

# lets try getting the ts with excel

library(readxl)
library(tidyr)


monthly <- read_xlsx(
  "examples/je-d-03.03.01.01.xlsx",
  sheet = 2,        # select only 2nd sheet 
  col_names = FALSE # keep excel row numbers
)

# subset only the rows 3 (= month) and 4 (= total), drop the label column
total <- monthly[4, -1] 
names(total) <- unlist(monthly[3, -1])

# pivot data longer (from excel wide format to data frame long format)
unemp_long <- total |>
  pivot_longer(
    cols = everything(),
    names_to = "Month",
    values_to = "Unemployed"
  )
# str(unemp_long)

# convert unemployed to num and month to date
total_long$Unemployed <- as.numeric(total_long$Unemployed)
total_long$Date <- seq(
  as.Date("1991-01-01"),
  by = "month",
  length.out = nrow(total_long)
)

head(total_long, n = 10)
