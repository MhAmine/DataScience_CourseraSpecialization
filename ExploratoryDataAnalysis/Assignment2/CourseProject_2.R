rm(list=ls())

setwd("~/Dropbox/OnlineCourses/2015_DataScience_Spec/2016_ExploratoryDataAnalysis/CourseProject_2/")

NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

### Plot 1
NEI <- readRDS("summarySCC_PM25.rds")
total <- aggregate(Emissions ~ year, data = NEI, FUN = sum)


png("plot1.png", width = 5, height = 5, units = 'in', res = 300)
plot(total$year, total$Emissions, type = "b",  
     main = "Total Emissions all sources", xlab = "Year", ylab = expression("log " * PM[2.5]), col = "blue")

dev.off()


### Plot 2
NEI <- readRDS("summarySCC_PM25.rds")
baltimore <- subset(NEI, fips == "24510")

total <- aggregate(Emissions ~ year, data = baltimore, FUN = sum)

png("plot2.png", width = 5, height = 5, units = 'in', res = 300)
plot(total$year, total$Emissions, type = "b",
        main = "Total Emissions in Baltimore City, MD", xlab = "Year", ylab = expression("log " * PM[2.5]),
        col = "blue")

dev.off()


### Plot 3
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
NEI <- transform(NEI, type = factor(type))

baltimore <- subset(NEI, fips == "24510")
total <- aggregate(Emissions ~ year + type, data = baltimore, FUN = sum)

png(file="plot3.png", width=8, height=5, units = 'in', res = 300)
g <- ggplot(total, aes(year, Emissions))
g + geom_point() + geom_line() + facet_grid(. ~ type) +
  labs(x = "year", y = expression("log " * PM[2.5])) + labs(title = "PM25 Emissions Baltimore City, MD")

dev.off()
  

### Plot 4
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")
SCC <- readRDS("Source_Classification_Code.rds")

NEI_SCC <- merge(NEI, SCC, by = "SCC") 
filter <- grepl("coal", NEI_SCC$Short.Name, ignore.case = TRUE)

coal <- NEI_SCC[filter,]

png(file="plot4.png", width=5, height=5, units = 'in', res = 300)
g <- ggplot(coal, aes(factor(year), log10(Emissions)))
g + geom_boxplot() +
  labs(x = "year", y = expression("log " * PM[2.5])) + ggtitle("Coal combustion related emission")

dev.off()


### Plot 5
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")

baltimore_motor <- subset(NEI, fips == "24510" & type == "ON-ROAD")

png(file="plot5.png", width=5, height=5, units = 'in', res = 300)
g <- ggplot(baltimore_motor, aes(factor(year), log10(Emissions)))
g + geom_boxplot() +
  labs(x = "year", y = expression("log " * PM[2.5])) + ggtitle("Emissions from motor vehicle sources in Baltimore")

dev.off()



### Plot 6
library(ggplot2)
NEI <- readRDS("summarySCC_PM25.rds")

baltimore <- subset(NEI, fips == "24510" & type == "ON-ROAD")
baltimore$city <- rep("BaltimoreCity", times = dim(baltimore)[1])

LA_county <- subset(NEI, fips == "06037" & type == "ON-ROAD")
LA_county$city <- rep("LA_county", times = dim(LA_county)[1])

data <- rbind(baltimore, LA_county) 

png(file="plot6.png", width=6, height=5, units = 'in', res = 300)
g <- ggplot(data, aes(factor(year), log10(Emissions)))
g + geom_boxplot() + facet_grid(. ~ city) + 
  labs(x = "year", y = expression("log " * PM[2.5])) + 
  ggtitle("Emissions from motor vehicle sources in Baltimore vs. LA county")

dev.off()