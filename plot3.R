#if the data is not alread cleaned, use this conditional to create
#subset that we need to evaluate and combine date and time into one variable
require(data.table)
if(!file.exists("hpc_cleaned.csv")){
        use <- fread("household_power_consumption.txt", sep = ";",stringsAsFactors=FALSE)
        use1 <- paste(use$Date, use$Time)
        use2 <- strptime(use1, format = "%d/%m/%Y %H:%M:%S")
        use <- data.frame(use, datetime = use2)
        use.sub <- subset(use, use$datetime>="2007-02-01" & use$datetime<="2007-02-03")
        write.csv(use.sub,file="hpc_cleaned.txt")
        rm(list = ls())
}
#import the cleaned data
use <- read.csv("hpc_cleaned.txt", stringsAsFactors=F)
#set the device as png with the proper settings
png(file="plot3.png",width=480,height=480) 
#Create the plot
ts1 <- ts(use$Sub_metering_1)
ts2 <- ts(use$Sub_metering_2)
ts3 <- ts(use$Sub_metering_3)
ts.plot(ts1, ts2, ts3,
        gpars = list(        
                xlab = NULL,
                ylab = "Energy sub metering",
                axes =F),
        col = c("black", "red", "blue"))
axis(2)
axis(1, at =c(1, length(ts1)/2, length(ts1)), labels=c("Thu","Fri","Sat")) 
box()
legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1,1),lwd=c(.5,.5,.5),col=c("black","red","blue"))
#Write the file
dev.off()



