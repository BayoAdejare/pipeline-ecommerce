# In Azure Databricks notebook

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum, avg, count, to_date, date_format

# Initialize Spark session
spark = SparkSession.builder.appName("SalesDataAnalysis").getOrCreate()

# Read sales data from Azure Data Lake
sales_data = spark.read.parquet("abfss://processed-data@yourdatalake.dfs.core.windows.net/sales_data/")

# Convert order date to date column
sales_data = sales_data.withColumn("order_date", to_date(col("order_timestamp")))

# Calculate sales metrics by date and product
daily_sales = sales_data.groupBy("order_date", "product_id") \
                .agg(sum("quantity").alias("total_units_sold"),
                     sum("total_amount").alias("total_revenue"),
                     avg("order_amount").alias("avg_order_value"))

# Calculate overall sales KPIs
total_revenue = sales_data.agg(sum("total_amount").alias("total_revenue")).collect()[0]["total_revenue"]
total_units_sold = sales_data.agg(sum("quantity").alias("total_units_sold")).collect()[0]["total_units_sold"]
avg_order_value = sales_data.agg(avg("order_amount").alias("avg_order_value")).collect()[0]["avg_order_value"]

# Write sales metrics to Azure SQL Database
daily_sales.write \
    .format("jdbc") \
    .option("url", "jdbc:sqlserver://yourserver.database.windows.net:1433;database=yourdatabase") \
    .option("dbtable", "daily_sales_metrics") \
    .option("user", "yourusername") \
    .option("password", "yourpassword") \
    .mode("overwrite") \
    .save()

# Write overall sales KPIs to Azure SQL Database
spark.createDataFrame([(total_revenue, total_units_sold, avg_order_value)], ["total_revenue", "total_units_sold", "avg_order_value"]) \
    .write \
    .format("jdbc") \
    .option("url", "jdbc:sqlserver://yourserver.database.windows.net:1433;database=yourdatabase") \
    .option("dbtable", "sales_kpis") \
    .option("user", "yourusername") \
    .option("password", "yourpassword") \
    .mode("overwrite") \
    .save()