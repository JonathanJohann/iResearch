#! /usr/bin/env Rscript
#install.packages(c("CombMSC","leaps","AICcmodavg"))
library(CombMSC)
library(leaps)
library(AICcmodavg)

sink('data_mining_2.txt')

set.seed(11152016)
setwd('/Users/Jonathan/Documents/Independent_Research')
dat = read.csv("bostonhousing.csv",header=TRUE)
dat<-dat[complete.cases(dat),]
sample_size <- floor(0.80 * nrow(dat))
train_ind <-sample(seq_len(nrow(dat)),size=sample_size)

train <- dat[train_ind, ]
cross_val <- dat[-train_ind, ]
rownames(cross_val) <- 1:nrow(cross_val)

b <- train[c("CRIM","ZN","INDUS","CHAS","RM","AGE","DIS","RAD","PTRATIO","LSTAT")]
rownames(b) <- 1:nrow(b)

fit <- regsubsets(MEDV~CRIM+ZN+INDUS+CHAS+RM+AGE+DIS+RAD+PTRATIO+LSTAT,data=train,nbest=10,nvmax=10)
summary(fit)$which[order(summary(fit)$adjr2,decreasing=T)[1:3],]
for (i in 1:3){
  vals <-order(summary(fit)$adjr2,decreasing=T)[i]
  a <- as.integer(summary(fit)$which[vals,][1:ncol(b)+1])
  new_data<- data.frame(t(t(b)*a))
  new_data$MEDV = train$MEDV
  fit_temp <-lm(MEDV~CRIM+ZN+INDUS+CHAS+RM+AGE+DIS+RAD+PTRATIO+LSTAT,data=new_data)
  print("Model number: ");print(i)
  print("Rsq value is: ");print(summary(fit)$rsq[vals])
  print("Mallow's Cp value is: ");print(summary(fit)$cp[vals])
  print("AICc value is: ");print(AICc(fit_temp))
  print("Training RMSE value is: ");print(sqrt(mean(fit_temp$residuals^2)))
  print("Cross Validation R^2 value is: ")
  ss_res1 <-sum((predict(fit_temp,newdata=cross_val)-cross_val$MEDV)^2)
  cv_r21 <- 1-ss_res1/ss_tot
  print(cv_r21)
}

sink()

