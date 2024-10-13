# In Azure Databricks notebook

from pyspark.sql import SparkSession
from pyspark.sql.functions import col, sum, avg, count, datediff, to_date
from pyspark.ml.feature import VectorAssembler
from pyspark.ml.clustering import KMeansModel

# Initialize Spark session
spark = SparkSession.builder.appName("CustomerSegmentation").getOrCreate()

# Read customer and sales data from Azure Data Lake
customer_data = spark.read.parquet("abfss://processed-data@yourdatalake.dfs.core.windows.net/customer_data/")
sales_data = spark.read.parquet("abfss://processed-data@yourdatalake.dfs.core.windows.net/sales_data/")

# Join customer and sales data
customer_behavior = customer_data.join(sales_data, "customer_id")

# Calculate customer behavior features
customer_features = customer_behavior.groupBy("customer_id") \
                     .agg(count("order_id").alias("total_orders"),
                          avg("order_amount").alias("avg_order_value"),
                          datediff(max("order_timestamp"), min("order_timestamp")).alias("lifetime_days"))

# Prepare feature vector for clustering
featurizer = VectorAssembler(inputCols=["total_orders", "avg_order_value", "lifetime_days"], outputCol="features")
customer_data_for_clustering = featurizer.transform(customer_features)

# Train customer segmentation model
customer_segmentation_model = KMeansModel.train(customer_data_for_clustering, 5)

# Assign customers to segments
customer_segments = customer_segmentation_model.transform(customer_data_for_clustering)

# Write customer segments to Azure SQL Database
customer_segments.write \
    .format("jdbc") \
    .option("url", "jdbc:sqlserver://yourserver.database.windows.net:1433;database=yourdatabase") \
    .option("dbtable", "customer_segments") \
    .option("user", "yourusername") \
    .option("password", "yourpassword") \
    .mode("overwrite") \
    .save()