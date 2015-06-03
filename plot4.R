library(dplyr)
library(data.table)

# read the data from file into a table, use fread instead of read.table, faster
filedata <- fread("household_power_consumption.txt", 
                  sep = ";", header = T, na.strings=c("?",""), stringsAsFactors = FALSE)

# only subset the data from the dates 2007-02-01 and 2007-02-02
data <- filter(filedata, grep("^[1,2]/2/2007", Date))
#head(data)
#str(data)

# convert Date column from character format "%d/%m/%Y" to date format: %Y-%m-%d
data[, Date := as.Date(data$Date, "%d/%m/%Y")]
#data[1, data$Date]

# paste Date+Time column to datetime, then to POSIXct as a new column named DateTime
data[, DateTime := as.POSIXct(strptime((paste(data$Date, data$Time)), 
                                       format = "%Y-%m-%d %H:%M:%S"))]
dtime <- data[, data$DateTime] 
#dtime

# convert to numeric data for the Y axis 
gblActivePower <- as.numeric(data[, data$Global_active_power])
subMetering1 <- as.numeric(data[, data$Sub_metering_1])
subMetering2 <- as.numeric(data[, data$Sub_metering_2])
subMetering3 <- data[, data$Sub_metering_3]
voltage <- as.numeric(data[, data$Voltage])
gblReactivePower <- as.numeric(data[, data$Global_reactive_power])

# use png device, save the plot to png file
png(filename = "plot4.png", 
    width=480, height=480, units = "px", bg = "transparent")

# create 2 X 2 sub plots
par(mfrow = c(2, 2))

# row1, col1 plot 
plot(dtime, gblActivePower, type="l", ylab="Global Active Power")
# row1, col2 plot
plot(dtime, voltage, type="l", xlab="datetime", ylab="Voltage")
#row2, col1 plot
plot(dtime, subMetering1, type="l",  main = "", xlab = "", ylab = "Energy sub metering")
points(dtime, subMetering2, type = "l", col = "Red")
points(dtime, subMetering3, type = "l", col = "Blue")
legendLabel <- names(data)[7:9]
legend("topright", legend = legendLabel, 
        col = c("Black", "Red", "Blue"), lty = 1, lwd = 1, bty= "n")
#row2, col2 plot
plot(dtime, gblReactivePower, type="l", xlab="datetime", ylab="Global_reactive_power")

#close device
dev.off()
