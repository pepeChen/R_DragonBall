
# 讀取資料
train0 <- read.csv("train.csv", stringsAsFactors = FALSE)

# 計算總樓層面積，並做標準化轉換
train0SF <- train0 %>% 
  mutate(
    TotalSF = TotalBsmtSF + X1stFlrSF + X2ndFlrSF,
    TotalSF_stand = scale(TotalSF)) %>%
  select(Id, SalePrice, TotalSF, TotalSF_stand, TotalBsmtSF, X1stFlrSF, X2ndFlrSF)

# 總樓層面積range : 334~11752
range(train0SF$TotalSF)

# 標準化後總樓層面積range : -2.7175~11.1778
range(train0SF$TotalSF_stand)

