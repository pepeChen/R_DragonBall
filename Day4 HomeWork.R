
# 本日小挑戰(Day 4)
# 請試著改變 Random Forest 與 XGBoost 模型的參數，重新訓練模型並輸出各自的 rmse

# Load data
dataset <- read.csv("train_new.csv", stringsAsFactors = T)

# select features you want to put in models
dataset <- dataset %>% 
  select(
    SalePrice_log, 
    MSZoning,
    Neighborhood,
    TotalSF_stand,
    HeatingQC,
    TotRmsAbvGrd,
    GarageCars,
    CentralAir,
    Utilities
  )

# Splitting the dataset into the Training set and Validation set
set.seed(1)
split <- sample.split(dataset$SalePrice_log, SplitRatio = 0.8)
training_set <- subset(dataset, split == TRUE)
val_set <- subset(dataset, split == FALSE)


### RF Model
# Fitting Random Forest Regression to the dataset library(randomForest)
set.seed(1)

regressor <- randomForest(formula = SalePrice_log ~ .,
                          data = training_set,
                          ntree = 300,
                          mtry = 3)

# Predicting the Test set results
y_pred <- predict(regressor, newdata = val_set)

# performance evaluation : 0.1470777
rmse(val_set$SalePrice_log, y_pred)


### XGBoost Model
# transfer all feature to numeric
training_set_new <- training_set %>% select(-SalePrice_log)
val_set_new <- val_set %>% select(-SalePrice_log)

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
             max_depth = 5,
             min_child_weight = 3,
             subsample = 0.8,
             colsample_bytree = 0.9
)

# Fitting XGBoost to the Training set
set.seed(1)
regressor <- xgb.train(params = param, data = dtrain, nrounds = 1000)

# Predicting the Test set results
y_pred <- predict(regressor, dval)

# performance evaluation : 0.1887305
rmse(val_set$SalePrice_log, y_pred)

