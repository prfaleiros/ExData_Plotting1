# load libraries needed to get data ready
library(sqldf)
library(lubridate)
library(dplyr)

# check file existence and download it if does not exists
# ASSUMPTION: there is internet connection
fn <- "./household_power_consumption.txt"
if(!file.exists(fn)) {
  fileURL <-
    "https://d396qusza40orc.cloudfront.net/exdata%2Fdata%2Fhousehold_power_consumption.zip"
  download.file(fileURL, destfile = "./household_power_consumption.zip", method = "auto")
  
  unzip(zipfile="./household_power_consumption.zip")
} 

# read file filtering only needed data (Feb 1st and 2nd, 2007)
df <-
  read.csv.sql(
    fn,
    sql = 'select * from file where Date = "1/2/2007" or Date = "2/2/2007"',
    header = TRUE,
    sep = ";",
    row.names = FALSE
  )

# add new datetime column with proper datatype
tsMeas = dmy(df$Date) + hms(df$Time)
df <- cbind(df, tsMeas)

# plot 2 - Global Active Power x datetime
png(
  filename = "plot2.png",
  width = 480,
  height = 480,
  units = "px",
  pointsize = 12,
  bg = "white",
  res = NA,
  family = "",
  restoreConsole = TRUE,
  type = c("windows", "cairo", "cairo-png")
)
with (
  df,
  plot(
    tsMeas,
    Global_active_power,
    type = "n",
    ylab = "Global Active Power (kilowatts)",
    xlab = ""
  )
)
with (df, lines(tsMeas, Global_active_power))
dev.off()

