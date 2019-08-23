# 本日小挑戰(Day 6)
# 如何得出模型的 R-Squared

#load packages
library(caTools)
library(caret)
library(dplyr)
library(xgboost)
library(Metrics)

# Loading data
dataset <- read.csv("train_new.csv")

# select features you want to put in models
dataset <- dataset %>% 
  select(SalePrice_log, X1stFlrSF, TotalBsmtSF, 
         YearBuilt, LotArea, Neighborhood, GarageCars, GarageArea, GrLivArea_stand, 
         MasVnrArea_stand, LotFrontage_log, is_Fireplace, TotalBathrooms, TotalSF_stand)

# Splitting the dataset into the Training set and Validation set
set.seed(1)
split <- sample.split(dataset$SalePrice_log, SplitRatio = 0.8)
training_set <- subset(dataset, split == TRUE)
val_set <- subset(dataset, split == FALSE)

# (Linear Regression)
# Fitting Multiple Linear Regression to the Training set
Reg <- lm(formula = SalePrice_log ~ ., data = training_set)

# (XGBoost)
# transfer all feature to numeric
training_set_new <- training_set %>% dplyr::select(-SalePrice_log)
val_set_new <- val_set %>% dplyr::select(-SalePrice_log)
cat_index <- which(sapply(training_set_new, class) == "factor")
training_set_new[cat_index] <- lapply(training_set_new[cat_index], as.numeric)
val_set_new[cat_index] <- lapply(val_set_new[cat_index], as.numeric)

# put testing & training data into two seperates Dmatrixs objects
labels <- training_set$SalePrice_log
dtrain <- xgb.DMatrix(data = as.matrix(training_set_new),label = labels) 
dval <- xgb.DMatrix(data = as.matrix(val_set_new))

# set parameters
param <-list(objective = "reg:linear",
             booster = "gbtree",
             eta = 0.01, #default = 0.3
             gamma=0,
             max_depth=3, #default=6
             min_child_weight=4, #default=1
             subsample=1,
             colsample_bytree=1
)

# Fitting XGBoost to the Training set
set.seed(1)
xgb_base <- xgb.train(params = param, data = dtrain, nrounds = 3000)

### Linear Regression R2 : 0.75025
y_mean <- mean(val_set$SalePrice_log)
n <- as.numeric(nrow(val_set))

y_pred_LR <- predict(Reg, newdata = val_set)
SSE_LR <- sum((val_set$SalePrice_log - y_pred_LR)**2)
SST_LR <- sum((val_set$SalePrice_log - y_mean)**2)

R2_LR <- 1-(SSE_LR/SST_LR)

### XGBoost R2 : 0.77827
y_pred_XGB <- predict(xgb_base, newdata = dval)
SSE_XGB <- sum((val_set$SalePrice_log - y_pred_XGB)**2)
SST_XGB <- sum((val_set$SalePrice_log - y_mean)**2)

R2_XGB <- 1-(SSE_XGB/SST_XGB)


