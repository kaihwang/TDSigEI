# run stats on the MTD estimates
library(ggplot2)
library(plyr)
library(reshape2)
library(scales)
library("psyphy")
library("grid")
library('lme4')
library('lsmeans')        # data are saved in google share folder
setwd("/Volumes/neuro/bin/TDSigEI/Data/")
Data = read.csv('NuiMTD.csv', header=TRUE)
Data <- Data[Data$Window == 15,] #keep optimal window


Data<-Data[Data$Condition!='Hp',]

Data<-Data[Data$Condition!='Fp',]

levels(Data$Condition) <- c("F","F","H","H")
summary(aov(corr.PPA.VC ~ Category  + Error (Subj/(Category )), data = Data))

#ttest
Data<-melt(Data, c('Subj','Condition'))
CI_colors <- c('#CA0020', '#F4A582' , '#0571B0', '#92C5DE')
ggplot(data=Data, aes(x=Condition, y=value)) +facet_grid(~variable) +geom_boxplot(aes(fill=Condition))+scale_fill_manual(values=CI_colors )+ theme_grey(base_size = 24)



t.test(Data[(Data$Condition=='FH' & Data$variable=='MTD.FFA.VC'),4], Data[(Data$Condition=='Fp' & Data$variable=='MTD.FFA.VC'),4], paired=TRUE)


#

Data = read.csv('NuiMTD.csv', header=TRUE)
Data<- melt(Data, id.vars=c("Condition", "Subj"))
g<-ggplot(data=Data, aes(x=Condition, y=value)) +facet_grid(~variable) +geom_boxplot(aes(fill=Condition))+scale_fill_manual(values=CI_colors )+ theme_grey(base_size = 24) + ylab("Pearson Correlation") +ylim(-.25, .65)
ggsave(filename = 'MTD_nui.pdf', plot = g, units = c("in"),width = 9.32, height=6.5,dpi=300) 
