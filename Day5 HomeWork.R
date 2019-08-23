# 本日小挑戰
# 機器學習中如何處理 “Bias-Variance Tradeoff” 的問題？
# 
# 我們希望將Bias error與varinace error透過權衡方式達到Total error最小，
# 往往是去選擇模型建置的複雜度，透過train/validate set去觀察模型複離度，
# 是有underfitting or overfitting的狀況，
# 而前述2種狀況，可透過下述調整方式進度：
# 
# 【Underfitting】
# 發生 Underfitting 的根本原因是由於模型太過簡單，解決方案就是提高模型的複雜度，可以透過：
# 增加訓練的疊代次數
# 1.調整超參數 
# 2.生成更多的特徵來訓練模型
# 3.更換一個更複雜的模型
# 
# 【Overfitting】
# 發生 Overfitting 的根本原因是由於模型太過複雜，解決方案就是降低模型的複雜度，可以透過：
# Early Stopping
# 1.增加訓練資料
# 2.降低特徵維度
# 3.調整超參數
# 4.更換一個較為簡單的模型
