# advantage: get all by one go, filter, redo - always get up to date, reproducible, etc. 
# devtools::install_github("lgnbhl/BFS")

library(tidyverse)
library(BFS)

catalog <- bfs_get_catalog_data(language = "en", title = "energy")
dataset_nr <- catalog$number_bfs[1]
energy_df <- bfs_get_data(dataset_nr, lang = "en")

# filter only total energy accounts
total_energy <- subset(
  energy_df,
  # select only totals for each of the columns 
  `Economy and households` == "Economy and households - Total" &
  `Energy product` == "Energy product - Total",
  select = c(Year, `Energy accounts of economy and households`)
)

names(total_energy)[2] <- "Amount"

View(total_energy)


# example query https://www.pxweb.bfs.admin.ch/api/v1/en/px-x-0204000000_106/px-x-0204000000_106.px



#### import gdp data manually
library(readxl)

data <- read_xlsx("examples/je-d-04.02.01.03.xlsx") 

# inspect data
# head(data)
# View(data)

# subset only the rows 3 (= year) and 9 (= gdp)
gdp <- data[9,]
names(gdp) <- data[3,]

# pivot data longer (from excel wide format to data frame long format)
gdp_long <- gdp |>
  tidyr::pivot_longer(
    cols = everything(),
    names_to = "Year",
    values_to = "GDP"
  )

# remove old headers 
gdp_long <- gdp_long[-c(1:2),]

# check structure
# str(gdp_long)

# convert to gdp numeric and year to year
gdp_long$GDP <- as.numeric(gdp_long$GDP)
gdp_long$Year <- as.integer(gdp_long$Year)

head(gdp_long)
