library(dplyr)
library(data.table)

# read the data from file into a table, use fread instead of read.table, faster
filedata <- fread("household_power_consumption.txt", 
  sep = ";", header = T, na.strings=c("?",""), stringsAsFactors = FALSE)

# only subset the data from the dates 2007-02-01 and 2007-02-02
data <- filter(filedata, grep("^[1,2]/2/2007", Date))
#head(data)

# convert the data from character to numeric
gblActivePower <- as.numeric(data[, data$Global_active_power])

# use png device, save the plot to png file
png(filename = "plot1.png", 
    width=480, height=480, units = "px", bg = "transparent")

# plot global active power
hist(gblActivePower, col="Red", main="Global Active Power", xlab="Global Active Power (kilowatts)")

#close device
dev.off()
