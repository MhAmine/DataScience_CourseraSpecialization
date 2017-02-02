# Read data
data = read.table("household_power_consumption.txt", sep = ";", header = T, na.strings="?")

data = data[2:dim(data)[1],]
data[,1] = as.Date(data[,1], format = "%d/%m/%Y")

filter = grepl("2007-02-01|2007-02-02", data[,1])
data = data[filter,]

data_time = strptime(data[,2], format = "%H:%M:%S")
data_time = format(data_time, "%H:%M:%S")

data[,2] = data_time
data[,3:9] = as.numeric(unlist(data[,3:9]),nrow=nrow(data[,3:9]))

datetime <- paste(as.Date(data$Date), data$Time)
data$Datetime <- as.POSIXct(datetime)

# Plot 1
png("plot1.png", width = 480, height = 480)
hist(data$Global_active_power, col = "red", 
                xlab = "Global Active Power (kilowatts)", main = "Global Active Power")

dev.off()


# Plot 2
png("plot2.png", width = 480, height = 480)
plot(data$Datetime, data$Global_active_power, type = "l", xlab = "",
     ylab = "Global Active Power (kilowatts)", main = "")

dev.off()

# Plot 3
png("plot3.png", width = 480, height = 480)
plot(data$Datetime, data$Sub_metering_1, type = "l", xlab = "",
     ylab = "Energy sub metering", main = "")
lines(data$Datetime, data$Sub_metering_2, type = "l", xlab = "", col = "red")
lines(data$Datetime, data$Sub_metering_3, type = "l", xlab = "", col = "blue")
legend("topright", pch = 1, col = c("blue", "red"), legend = c("Sub_metering_1",
                                                               "Sub_metering_2",
                                                               "Sub_metering_3"))

dev.off()

# Plot 4
png("plot4.png", width = 480, height = 480)

par(mfrow = c(2, 2), mar = c(4, 4, 2, 2))

plot(data$Datetime, data$Global_active_power, type = "l", xlab = "",
     ylab = "Global Active Power (kilowatts)", main = "", region = "northwest")

plot(data$Datetime, data$Voltage, type = "l", xlab = "datetime",
     ylab = "Voltage", main = "", region = "northeast")

plot(data$Datetime, data$Sub_metering_1, type = "l", xlab = "",
     ylab = "Energy sub metering", main = "", region = "southwest")
lines(data$Datetime, data$Sub_metering_2, type = "l", xlab = "", col = "red")
lines(data$Datetime, data$Sub_metering_3, type = "l", xlab = "", col = "blue")
legend("topright", pch = 1, col = c("blue", "red"), legend = c("Sub_metering_1",
                                                               "Sub_metering_2",
                                                               "Sub_metering_3"))

plot(data$Datetime, data$Global_reactive_power, type = "l", xlab = "datetime",
     ylab = "Global_reactive_power", main = "", region = "southeast")

dev.off()




