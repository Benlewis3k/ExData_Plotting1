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
png(file="plot4.png",width=480,height=480) 
#define variables
use1 <- ts(use$Global_active_power)
use2 <- ts(use$Voltage)
use3 <- ts(use$Global_reactive_power)
ts1 <- ts(use$Sub_metering_1)
ts2 <- ts(use$Sub_metering_2)
ts3 <- ts(use$Sub_metering_3)
#create the 4 plots
par(mfrow=c(2,2))
with(use,{plot.ts(use1,
                  ylab = "Global Active Power",
                  axes =F,
                  xlab = NULL)
          box()
          axis(2)
          axis(1, at =c(1, length(use1)/2, length(use1)), labels=c("Thu","Fri","Sat"))
          plot.ts(use2,
                  ylab = "Voltage",
                  axes =F,
                  xlab = "datetime")
          box()
          axis(2)
          axis(1, at =c(1, length(use1)/2, length(use1)), labels=c("Thu","Fri","Sat"))
          
          ts.plot(ts1, ts2, ts3,
                  gpars = list(        
                          xlab = NULL,
                          ylab = "Energy sub metering",
                          axes =F),
                  col = c("black", "red", "blue"))
          axis(2)
          axis(1, at =c(1, length(ts1)/2, length(ts1)), labels=c("Thu","Fri","Sat")) 
          box()
          legend("topright", c("Sub_metering_1","Sub_metering_2","Sub_metering_3"),lty=c(1,1,1),lwd=c(.5,.5,.5),bty="n",col=c("black","red","blue"))
          plot.ts(use3,
                  ylab = "Gloabl_reactive_power",
                  axes =F,
                  xlab = "datetime")
          box()
          axis(2)
          axis(1, at =c(1, length(use1)/2, length(use1)), labels=c("Thu","Fri","Sat"))
})
#Write the file
dev.off()