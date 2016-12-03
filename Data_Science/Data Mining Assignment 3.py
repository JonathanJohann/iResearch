

import pandas as pd

#%%


df = pd.read_csv("GermanCredit.csv",sep=',',header=0)

#%%

df.head()

#%%
from sklearn.linear_model import LogisticRegression
from sklearn.ensemble import RandomForestClassifier,AdaBoostClassifier
from sklearn.tree import DecisionTreeClassifier
from sklearn.neural_network import MLPClassifier
from sklearn.discriminant_analysis import LinearDiscriminantAnalysis
from sklearn.model_selection import train_test_split


predictors,predicted = df.columns.values[:-1],df.columns.values[-1]

log_reg = LogisticRegression()
random_forest = RandomForestClassifier()
adaboost = AdaBoostClassifier()
decision_tree = DecisionTreeClassifier()
neural_net = MLPClassifier()
lda = LinearDiscriminantAnalysis()

train,test = train_test_split(df,test_size=0.2)

#%%

log_reg.fit(train[predictors],train[predicted])
random_forest.fit(train[predictors],train[predicted])
adaboost.fit(train[predictors],train[predicted])
decision_tree.fit(train[predictors],train[predicted])
neural_net.fit(train[predictors],train[predicted])
lda.fit(train[predictors],train[predicted])

#%%

log_reg_predictions = log_reg.predict(test[predictors])
random_forest_predictions = random_forest.predict(test[predictors])
adaboost_predictions = adaboost.predict(test[predictors])
decision_tree_predictions = decision_tree.predict(test[predictors])
neural_net_predictions = neural_net.predict(test[predictors])
lda_predictions = lda.predict(test[predictors])

#%%

