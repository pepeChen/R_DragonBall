
# 本日小挑戰(Day2)
# 請挑選 training data 中你覺得其他重要的欄位，和房價有什麼關係。


# 讀取資料
train0 <- read.csv("train.csv", stringsAsFactors = FALSE)

# 篩選HeatingQC的欄位 
train_HeatingQC <- select(train0, matches("HeatingQC|SalePrice")) %>%
  gather(-SalePrice, key = "var", value = "value")

# 轉換成Factor
train_HeatingQC$value <- factor(train_HeatingQC$value,
                                levels=c("Ex","Gd","TA","Fa","Po"))
# HeatingQC: Heating quality and condition
# 
# Ex	Excellent
# Gd	Good
# TA	Average/Typical
# Fa	Fair
# Po	Poor

# Plot
train_HeatingQC %>%	
  ggplot(aes(x = value, y = SalePrice)) +   # Plot the values
  facet_wrap(~ var, scales = "free") +   # In separate panels
  geom_boxplot(na.rm = T) +
  theme(axis.text.x = element_text(angle = 90, hjust = 1))

# 由箱形圖知道房價與屋內加熱品質(HeatingQC)是正成比，屋內加熱品質(HeatingQC)愈好其房價愈佳

