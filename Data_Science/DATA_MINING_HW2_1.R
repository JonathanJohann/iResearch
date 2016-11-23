#install.packages(c('tree'))
library(tree)

sink('data_mining_2_9.txt')
set.seed(11152016)
setwd('/Users/Jonathan/Documents/Independent_Research')
dat = read.csv("toyotacorolla.csv",header=TRUE)
dat<-dat[complete.cases(dat),]
train_size <- floor(0.50 * nrow(dat))
train_ind <-sample(seq_len(nrow(dat)),size=train_size)
train <- dat[train_ind, ]
other <- dat[-train_ind, ]

cv_size <- floor(0.60 * nrow(other))
cv_ind <-sample(seq_len(nrow(other)),size=cv_size)
cross_val <- other[cv_ind, ]

test <- other[-cv_ind, ]

rownames(train) <- 1:nrow(train)
rownames(cross_val) <- 1:nrow(cross_val)
rownames(test) <- 1:nrow(test)

tree1 <- tree(Price~Age_08_04+KM+Fuel_Type+HP+Automatic+Doors+Quarterly_Tax+
                Mfg_Guarantee+Guarantee_Period+Airco+Automatic_airco+CD_Player+Powered_Windows+
                Sport_Model+Tow_Bar,data=train,control=tree.control(nobs=nrow(train),mincut=1,minsize=2,mindev=0))

summary(tree1)
plot(tree1)
text(tree1,all=T)
print('R^2 value for training data:') 
1-sum((predict(tree1,newdata=train)-mean(train$Price))^2)/sum((train$Price-mean(train$Price))^2)

print('RMSE value for training data:')
sqrt(mean((predict(tree1,newdata=train)-train$Price)^2))

print('R^2 value for cross validation data:')
1-sum((predict(tree1,newdata=cross_val)-mean(cross_val$Price))^2)/sum((cross_val$Price-mean(cross_val$Price))^2)

print('RMSE value for cross validation data:')
sqrt(mean((predict(tree1,newdata=cross_val)-cross_val$Price)^2))

print('R^2 value for test data:')
1-sum((predict(tree1,newdata=test)-mean(test$Price))^2)/sum((test$Price-mean(test$Price))^2)

print('RMSE value for test data:')
sqrt(mean((predict(tree1,newdata=test)-test$Price)^2))


vec <- c()
for (i in 2:5){
  tree2 <- prune.tree(tree1,newdata=model.frame(cross_val),best=i)
  print(summary(tree2))  
  print("For number of splits:");print(i)
  print(1-sum((predict(tree2,newdata=cross_val)-mean(cross_val$Price))^2)/sum((cross_val$Price-mean(cross_val$Price))^2))
}

tree3<-prune.tree(tree1,newdata=model.frame(cross_val),best=2)
print('===================================================================')
print('For the new reduced tree:')
print('R^2 value for training data:') 
1-sum((predict(tree3,newdata=train)-mean(train$Price))^2)/sum((train$Price-mean(train$Price))^2)

print('RMSE value for training data:')
sqrt(mean((predict(tree3,newdata=train)-train$Price)^2))

print('R^2 value for cross validation data:')
1-sum((predict(tree3,newdata=cross_val)-mean(cross_val$Price))^2)/sum((cross_val$Price-mean(cross_val$Price))^2)

print('RMSE value for cross validation data:')
sqrt(mean((predict(tree3,newdata=cross_val)-cross_val$Price)^2))

print('R^2 value for test data:')
1-sum((predict(tree3,newdata=test)-mean(test$Price))^2)/sum((test$Price-mean(test$Price))^2)

print('RMSE value for test data:')
sqrt(mean((predict(tree3,newdata=test)-test$Price)^2))

sink()