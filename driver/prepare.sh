rm -rf /opt/spark-data/data

cat << EOF | /opt/spark/bin/spark-shell \
    --jars /opt/spark-apps/spark-sql-perf_2.12-0.5.1-SNAPSHOT.jar \
    --master spark://spark-master:7077

import com.databricks.spark.sql.perf.tpcds.TPCDSTables

val rootDir = "/opt/spark-data/data"
val dsdgenDir = "/opt/spark-data/tpcds-kit/tools"
val scaleFactor = "1"
val format = "parquet"
val databaseName = "tpcds1g"
val sqlContext = spark.sqlContext

val tables = new TPCDSTables(sqlContext,
    dsdgenDir = dsdgenDir,
    scaleFactor = scaleFactor,
    useDoubleForDecimal = true,
    useStringForDate = true)

tables.genData(
    location = rootDir,
    format = format,
    overwrite = true,
    partitionTables = true,
    clusterByPartitionColumns = true,
    filterOutNullPartitionValues = false,
    tableFilter = "",
    numPartitions = 1024)

sql(s"create database \$databaseName") 

tables.createExternalTables(rootDir,
    format,
    databaseName,
    overwrite = true,
    discoverPartitions = true)

tables.analyzeTables(databaseName, analyzeColumns = true)

EOF
