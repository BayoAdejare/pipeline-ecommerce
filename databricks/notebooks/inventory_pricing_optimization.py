# In Azure Databricks notebook

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum, avg, min, max, lag, lead
from pyspark.ml.regression import LinearRegression

# Initialize Spark session
spark = SparkSession.builder.appName("InventoryPricingOptimization").getOrCreate()

# Read sales and product data from Azure Data Lake
sales_data = spark.read.parquet("abfss://processed-data@yourdatalake.dfs.core.windows.net/sales_data/")
product_data = spark.read.parquet("abfss://processed-data@yourdatalake.dfs.core.windows.net/product_data/")

# Join sales and product data
sales_product_data = sales_data.join(product_data, "product_id")

# Calculate sales velocity and profit margin
sales_product_metrics = sales_product_data.groupBy("product_id") \
                        .agg(sum("quantity").alias("total_units_sold"),
                             avg("total_amount").alias("avg_revenue_per_unit"),
                             min("price").alias("min_price"),
                             max("price").alias("max_price"))

# Train linear regression model to predict optimal price
price_optimizer = LinearRegression(labelCol="avg_revenue_per_unit", featuresCol="total_units_sold")
price_model = price_optimizer.fit(sales_product_metrics)

# Generate pricing and inventory recommendations
product_recommendations = sales_product_metrics.withColumn("optimal_price", price_model.predict(col("total_units_sold"))) \
                          .select("product_id", "total_units_sold", "min_price", "max_price", "optimal_price")

# Write recommendations to Azure SQL Database
product_recommendations.write \
    .format("jdbc") \
    .option("url", "jdbc:sqlserver://yourserver.database.windows.net:1433;database=yourdatabase") \
    .option("dbtable", "inventory_pricing_recommendations") \
    .option("user", "yourusername") \
    .option("password", "yourpassword") \
    .mode("overwrite") \
    .save()