library(dplyr)
library(data.table)

# read the data from file into a table, use fread instead of read.table, faster
filedata <- fread("household_power_consumption.txt", 
                  sep = ";", header = T, na.strings=c("?",""), stringsAsFactors = FALSE)

# only subset the data from the dates 2007-02-01 and 2007-02-02
data <- filter(filedata, grep("^[1,2]/2/2007", Date))
#head(data)

# convert Date column from character format "%d/%m/%Y" to date format: %Y-%m-%d
data[, Date := as.Date(data$Date, "%d/%m/%Y")]
#data[1, data$Date]

# paste Date+Time column to datetime, then to POSIXct as a new column named DateTime
data[, DateTime := as.POSIXct(strptime((paste(data$Date, data$Time)), 
                                       format = "%Y-%m-%d %H:%M:%S"))]
dtime <- data[, data$DateTime] 
#dtime

# convert the data from character to numeric
gblActivePower <- as.numeric(data[, data$Global_active_power])

# use png device, save the plot to png file
png(filename = "plot2.png", 
    width=480, height=480, units = "px", bg = "transparent")

# plot the data, x is the dtime, y is the gbl active power
# type is set to "l", lines
plot(dtime, gblActivePower, 
     type = "l", main = "", ylab = "Global Active Power (kilowatts)", xlab = "")

#close device
dev.off()
