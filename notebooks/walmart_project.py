# Databricks notebook source
df = spark.read.csv(
    "/Volumes/workspace/default/walmart_volume/Walmart.csv",
    header=True,
    inferSchema=True
)

display(df)


print("Rows:", df.count())
print("Columns:", len(df.columns))

df.printSchema()


df.write \
  .format("delta") \
  .mode("overwrite") \
  .saveAsTable("bronze_walmart")


df.printSchema()



silver_df = df.dropDuplicates()

print("Original Rows:", df.count())
print("Silver Rows:", silver_df.count())


silver_df.write \
    .format("delta") \
    .mode("overwrite") \
    .saveAsTable("silver_walmart")


from pyspark.sql.functions import sum
gold_store_sales = (
    silver_df
    .groupBy("Store")
    .agg(sum("Weekly_Sales").alias("Total_Sales"))
)

display(gold_store_sales)


gold_holiday_sales = (
    silver_df
    .groupBy("Holiday_Flag")
    .agg(sum("Weekly_Sales").alias("Total_Sales"))
)

display(gold_holiday_sales)


from pyspark.sql.functions import year

gold_year_sales = (
    silver_df
    .groupBy(year("Date").alias("Year"))
    .agg(sum("Weekly_Sales").alias("Total_Sales"))
)

display(gold_year_sales)


gold_store_sales.write \
    .format("delta") \
    .mode("overwrite") \
    .saveAsTable("gold_store_sales")


from pyspark.sql.functions import desc

top10_stores = (
    gold_store_sales
    .orderBy(desc("Total_Sales"))
)

display(top10_stores.limit(10))


from pyspark.sql.window import Window
from pyspark.sql.functions import rank

window_spec = Window.orderBy(desc("Total_Sales"))

ranked_stores = gold_store_sales.withColumn(
    "Rank",
    rank().over(window_spec)
)

display(ranked_stores)


from pyspark.sql.functions import dense_rank

dense_ranked_stores = gold_store_sales.withColumn(
    "Dense_Rank",
    dense_rank().over(window_spec)
)

display(dense_ranked_stores)


from pyspark.sql.functions import row_number

rownum_stores = gold_store_sales.withColumn(
    "Row_Num",
    row_number().over(window_spec)
)

display(rownum_stores)

from pyspark.sql.functions import month

monthly_sales = (
    silver_df
    .groupBy(month("Date").alias("Month"))
    .agg(sum("Weekly_Sales").alias("Total_Sales"))
    .orderBy("Month")
)

display(monthly_sales)


holiday_analysis = (
    silver_df
    .groupBy("Holiday_Flag")
    .agg(sum("Weekly_Sales").alias("Total_Sales"))
)

display(holiday_analysis)


print("Total Records:", df.count())

print("Duplicate Records Removed:",
      df.count() - silver_df.count())



from pyspark.sql.functions import col, count, when

df.select([
    count(when(col(c).isNull(), c)).alias(c)
    for c in df.columns
]).show()


    

 
