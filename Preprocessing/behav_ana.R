# script to analyze TDSigEI behavioral pilot.

# import libraries
library(ggplot2)
library(plyr)
library(reshape2)
library(scales)
library("psyphy")

# data are saved in google share folder
setwd("~/Google Drive/Projects/TDSigEI/Data")
path <- "~/Google Drive/Projects/TDSigEI/Data"


#Initialize dataframe
Data <-data.frame(Subj = character(),
                  Condition = character(), 
                  MotorMapping = integer(), 
                  Match = integer(), 
                  Accu = integer(), 
                  RH = integer(), 
                  LH = integer(), 
                  RT = numeric(), 
                  IbsetTune =numeric ())

# load data
Subjects <- c(503, 505, 508, 509, 510, 512, 513, 516, 517, 518, 519, 523, 527, 528,529,530,531,532,534,536,537,539,540,542,546,547,549,550)
for (s in Subjects) {
  file.names <- dir(path, pattern = paste("^.*", s, ".*\\.txt", sep=""))
  
  for (i in 1:length(file.names)) {
      tmpData <- read.table(file = file.names[i], header = FALSE, sep = "\t",
             colClasses = c("NULL", "factor", "factor", "integer", "integer", "integer", "integer", "integer", "numeric", "numeric", "NULL"),
             col.names = c(" ","Condtion", "MotorMapping", "Match", "Accu", "FA", "RH", "LH", "RT", "OnsetTime"," "))
      tmpData$Subj <- paste("S",s, sep="")
      Data <- rbind(Data, tmpData)
  }
}
Data[Data$RT==-1,"RT"]<-''
Data$RT<-as.numeric(Data$RT)
# tabulate
Stats.Accu <- tapply(Data$Accu, list(Data$Subj, Data$Condtion, Data$Match), mean)
Stats.RT <- tapply(Data$RT, list(Data$Subj, Data$Condtion, Data$Match), mean, na.rm = TRUE)

Stats.Accu <- tapply(Data$Accu, list(Data$Subj, Data$Condtion), mean)
Stats.RT <- tapply(Data$RT, list(Data$Subj, Data$Condtion), mean, na.rm = TRUE)

Stats.Accu <- tapply(Data$Accu, list(Data$Condtion, Data$Match), mean)
Stats.RT <- tapply(Data$RT, list(Data$Condtion, Data$Match), mean, na.rm = TRUE)
#inStats.RT <- tapply(Data$RT, list(Data$Condtion, Data$Match), mean, na.rm = TRUE)



