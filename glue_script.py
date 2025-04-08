import sys
from awsglue.transforms import *
from awsglue.utils import getResolvedOptions
from pyspark.context import SparkContext
from awsglue.context import GlueContext
from awsglue.job import Job
from pyspark.sql.functions import col, to_timestamp, window

# Initialize contexts
args = getResolvedOptions(sys.argv, ['JOB_NAME', 's3_input_path'])
sc = SparkContext()
glueContext = GlueContext(sc)
spark = glueContext.spark_session
job = Job(glueContext)
job.init(args['JOB_NAME'], args)

# === Configuration ===
#input_path = "s3://firehose-curated-data-amk/"  # Your curated S3 bucket
input_path = args['s3_input_path']
output_path = "s3://firehose-final-data-amk/events_summary/"  # Final ETL result bucket

# === Step 1: Read JSON data ===
df = spark.read.json(input_path)

# === Step 2: Parse event_time and create 1-minute windows ===
df = df.withColumn("event_time", to_timestamp(col("event_time")))

# === Step 3: Perform aggregations ===
summary = df.groupBy(
    window(col("event_time"), "1 minute"),
    col("event_type")
).count()

# Optional: Flatten the window column
summary = summary.select(
    col("window.start").alias("window_start"),
    col("window.end").alias("window_end"),
    col("event_type"),
    col("count")
)

# === Step 4: Write the output to S3 in Parquet format ===
#summary.write.mode("overwrite").csv(output_path)
summary.write.mode("overwrite") \
    .option("header", "true") \
    .option("delimiter", ",") \
    .csv(output_path)
    
job.commit()
