# script to analyze TDSigEI behavioral pilot.

# import libraries
library(ggplot2)
library(plyr)
library(reshape2)
library(scales)
library("psyphy")
library("grid")

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


### tabulate data
Stats.Accu <- tapply(Data$Accu, list(Data$Subj, Data$Condtion, Data$Match), mean)
Stats.RT <- tapply(Data$RT, list(Data$Subj, Data$Condtion, Data$Match), mean, na.rm = TRUE)

S#Stats.Accu <- tapply(Data$Accu, list(Data$Subj, Data$Condtion), mean)
#Stats.RT <- tapply(Data$RT, list(Data$Subj, Data$Condtion), mean, na.rm = TRUE)

#Stats.Accu <- tapply(Data$Accu, list(Data$Condtion, Data$Match), mean)
#Stats.RT <- tapply(Data$RT, list(Data$Condtion, Data$Match), mean, na.rm = TRUE)
#inStats.RT <- tapply(Data$RT, list(Data$Condtion, Data$Match), mean, na.rm = TRUE)



### calculate d-prime for FH
d<-{}
n <- 1
for (s in Subjects) {
  
  if (1-Stats.Accu[n,4,1]== 0){
    b = 0.00001}
  if (1-Stats.Accu[n,4,1]!= 0){
    b = 1-Stats.Accu[n,4,1]}
  if (Stats.Accu[n,4,2]!= 1){
    a = Stats.Accu[n,4,2]}
  if (Stats.Accu[n,4,2]== 1){
    a = 0.99999}
  
  d[n]<-dprime.SD(a, b) 
  
  n<-n+1
  
}
dprime_HF<-data.frame(d)
d<-{}

### calculate d-prime for HF
n <- 1
for (s in Subjects) {
  
  if (1-Stats.Accu[n,1,1]== 0){
    b = 0.000001}
  if (1-Stats.Accu[n,1,1]!= 0){
    b = 1-Stats.Accu[n,1,1]}
  if (Stats.Accu[n,1,2]!= 1){
    a = Stats.Accu[n,1,2]}
  if (Stats.Accu[n,1,2]== 1){
    a = 0.999999}
  
  d[n]<-dprime.SD(a, b) 
  
  n<-n+1
  
}
dprime_FH<-data.frame(d)



#### plotting
setwd("~/Google Drive/Projects/TDSigEI/")
Data = read.csv('data.csv', header=TRUE)

plt<-ggplot(Data, aes(x=T.PPA.VC, y=FIR_PPA_BF-FIR_PPA_Bp)) + geom_point(shape=19, size=3) + stat_smooth(method=lm, fullrange=TRUE) + theme_grey(base_size=24) 
plt <- plt + labs(x="", y="") 
plot(plt)
m <- lm(T.FFA.VC ~ FIR_FFA_FB-FIR_FFA_Fp, Data)
summary(m)
#ggsave(filename = "VC-FFA_Dprime.pdf", plot = plt, units = c("in"),width=6, height=6) 

#+ labs(x="MTD VC-FFA", y="D Prime for Face Targets") 

#### b-b corr
setwd("/Volumes/neuro/bin/TDSigEI/Data/")
Data = read.csv('brain_behav_corr.csv', header=TRUE)

#tmpData <-Data[Data$Condition=='HF',]
plt <-ggplot(Data, aes(x=MTD_Target-MTD_Dist, y=D_prime, colour = Condition)) + geom_point(shape=19, size=3) + stat_smooth(method=lm, fullrange=TRUE) + theme_classic(base_size=14)
plt <- plt + xlab("MTD Strength for Distractors") + ylab("Evoked Amplitude for Distractors") 
plot(plt)
ggsave(filename = 'MTD_FIR.pdf', plot = plt, units = c("in"),width=6.5, height=3.15,dpi=300) 

tmpD <- Data[Data$Condition == 'HF',]
m <- lm(FIR_Dist ~ MTD_Dist, tmpD)
summary(m)
