
# Database connection and data manipulation for Analysis -----------------------------------------------------


library(odbc)
library(DBI)
library(statisticalModeling)
library(factoextra)
library(corrplot)
library(dplyr)
library(leaps) # helps with function 
library(tidyverse)

con <- dbConnect(odbc::odbc(),
                 Driver = "SQL Server",
                 Server = "DEXTECH\\SQLEXPRESS",
                 Database = "HomePrediction",
                 Port = 1433)

dbListTables(con)
dbListFields(con, "train")

train_df <- tbl(con, "train")
train_df <- collect(train_df)

test_df <- tbl(con, "test")
test_df <- collect(test_df)


num <- unlist(lapply(train_df, is.numeric), use.names = FALSE) 
corrplot(cor(train_df[num]),method = 'number', tl.cex =0.5) # Correlation plot to see strongly correlated numeric columns

hist(train_df$SalePrice) # Observing data distribution for SalePrice
hist(log(train_df$SalePrice)) # Normalizing distribution by using the logarithm of SalePrice.


# Regression ------------------------------------------------

model_1 <- lm(log(SalePrice)  ~ LotArea + OverallQual + GrLivArea , data = train_df) # Initial Model
summary(model_1)


model_2 <- lm(log(SalePrice) ~OverallQual + GrLivArea + LotArea + Neighborhood, data = train_df) # Final model
summary(model_2)


prediction <- evaluate_model(model_2, test_df) # evaluating and prediction of model, displaying as output
summary(prediction)

predicted_sale_price <- exp(prediction$model_output) # Finding the antilog to return sales price to their natural numbered values.

head(predicted_sale_price)

predicted_table <- cbind(test_df,predicted_sale_price) # combining results to the test data to prepare for export

write.csv(predicted_table, file = 'predicted_table.csv', row.names = FALSE) #Exporting solution as a csv file.



