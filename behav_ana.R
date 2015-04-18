# script to analyze TDSigEI behavioral pilot.

# import libraries
library(ggplot2)
library(plyr)
library(reshape2)
library(scales)

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
Subjects <- c(101, 301)
for (s in Subjects) {
  file.names <- dir(path, pattern = paste("^.*", s, ".*\\.txt", sep=""))
  
  for (i in 1:length(file.names)) {
      tmpData <- read.table(file = file.names[i], header = FALSE, sep = "\t",
             colClasses = c("NULL", "factor", "factor", "integer", "integer", "integer", "integer", "numeric", "numeric", "NULL"),
             col.names = c(" ","Condtion", "MotorMapping", "Match", "Accu", "RH", "LH", "RT", "OnsetTime"," "))
      tmpData$Subj <- paste("S",s, sep="")
      Data <- rbind(Data, tmpData)
  }
}

# tabulate
Stats.Accu <- tapply(Data$Accu, list(Data$Condtion, Data$Match), mean)
Stats.RT <- tapply(Data$RT, list(Data$Condtion, Data$Match), mean)

