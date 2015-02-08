#if the data is not alread cleaned, use this conditional to create
#subset that we need to evaluate and combine date and time into one variable
require(data.table)
if(!file.exists("hpc_cleaned.csv")){
        use <- fread("household_power_consumption.txt", sep = ";",stringsAsFactors=FALSE)
        use1 <- paste(use$Date, use$Time)
        use2 <- strptime(use1, format = "%d/%m/%Y %H:%M:%S")
        use <- data.frame(use, datetime = use2)
        use.sub <- subset(use, use$datetime>="2007-02-01" & use$datetime<="2007-02-02")
        write.csv(use.sub,file="hpc_cleaned.txt")
        rm(list = ls())
}
#import the cleaned data
use <- read.csv("hpc_cleaned.txt", stringsAsFactors=F) 
#set the device as png with the proper settings
png(file="plot1.png",width=480,height=480) 
hist(use$Global_active_power,                    # apply the hist function 
     col="red",                                  # set color to red
     xlab = "Global Active Power (kilowatts)",   # label the x axis
     main = "Global Active Power")               # set the title
#write the file
dev.off()

