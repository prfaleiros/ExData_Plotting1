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


# plot 4
# 4 frames containing:
# Global Active Power x datetime
# Voltage x datetime
# Energy sub metering x datetime
# Global reactive power x datetime
png(
  filename = "plot4.png",
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
par(mfrow = c(2,2))
# graph a topleft position - Global active pwr x datetime
with (
  df,
  plot(
    tsMeas,
    Global_active_power,
    type = "n",
    ylab = "Global Active Power",
    xlab = ""
  )
)
with (df, lines(tsMeas, Global_active_power))

# graph a topright position - Voltage x datetime
with (df,
      plot(
        tsMeas,
        Voltage,
        type = "n",
        ylab = "Voltage",
        xlab = "datetime"
      ))
with(df, lines(tsMeas, Voltage, col = "black"))

# graph a bottomleft position - Energy sub metering x datetime
with (df,
      plot(
        tsMeas,
        Sub_metering_1,
        type = "n",
        ylab = "Energy sub metering",
        xlab = ""
      ))
with(df, lines(tsMeas, Sub_metering_1, col = "black"))
with(df, lines(tsMeas, Sub_metering_2, col = "red"))
with(df, lines(tsMeas, Sub_metering_3, col = "blue"))
legend(
  "topright",
  col = c("black", "red", "blue"),
  legend = c("Sub_metering_1", "Sub_metering_2", "Sub_metering_3"),
  lty = 1
)

# graph a bottomright position - Gbl reactive pwr x datetime
with (df,
      plot(
        tsMeas,
        Global_reactive_power,
        type = "n",
        ylab = "Global_reactive_power",
        xlab = "datetime"
      ))
with(df, lines(tsMeas, Global_reactive_power, col = "black"))
dev.off()
