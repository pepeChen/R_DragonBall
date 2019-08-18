##------------------------------------------------
## 本日小挑戰
##------------------------------------------------
#請挑選training data中1-3個你覺得重要的欄位，或好幾個性質類似的欄位，進行轉換，拆解，或合併（自由發揮）。

# 讀入資料集
train0<-read.csv("train.csv", stringsAsFactors = FALSE)

dcr0<-read.delim("data_description.txt", header = FALSE, stringsAsFactors = FALSE)
dcr<-dcr0%>%
  mutate(feature=sapply(strsplit(V1, '\t|[[:space:]]'), "[", 1))%>%  
  filter(!is.na(feature))%>%           
  mutate_all(na_if, "")%>%             
  fill(feature, .direction="down")%>% 
  rename(value=V1, description=V2)%>%
  select(feature, value, description)

# 描述檔中MSZoning的所有類別
dcr_ZoneType <- dcr %>% 
  filter(feature == "MSZoning:" & !is.na(description)) %>%
  mutate(MSZoning = str_trim(value)) %>%
  select(MSZoning)

# train data中MSZoning的所有類別
train0[train0$MSZoning == "C (all)", "MSZoning"] <- "C"
train_ZoneType <- train0 %>% 
  group_by(MSZoning) %>%
  summarise(count=n()) 

# 找出train data沒有的MSZoning
NA_ZoneType <- dcr_ZoneType %>%
  left_join(train_ZoneType, by = c("MSZoning"="MSZoning")) %>%
  filter(is.na(count)) %>%
  spread(MSZoning, count, fill=0) %>%
  rename_all(function(x) paste0("ZoneType_", x)) 

# MSZoning(房屋座落區域)
FG_ZoneType <- train0 %>% 
  group_by(Id, MSZoning) %>%
  summarise(count=n()) %>%
  spread(MSZoning, count, fill=0) %>%
  rename_all(function(x) paste0("ZoneType_", x)) 

#併回train data
train <- train0 %>%
  left_join(FG_ZoneType, by=c("Id"="ZoneType_Id")) %>%
  mutate(
    ZoneType_A = 0,
    ZoneType_I = 0,
    ZoneType_RP = 0
  )

viewtable <- train %>% 
  select(Id, contains("ZoneType"))
