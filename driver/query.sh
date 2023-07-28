cat << EOF | /opt/spark/bin/spark-shell \
    --jars /opt/spark-apps/spark-sql-perf_2.12-0.5.1-SNAPSHOT.jar \
    --master spark://spark-master:7077

import com.databricks.spark.sql.perf.tpcds.TPCDS

val sqlContext = spark.sqlContext
val tpcds = new TPCDS(sqlContext)

val databaseName = "tpcds10g" 
sql(s"use \$databaseName")

val resultLocation = "/opt/spark-data/results"

// how many iterations of queries to run.
val iterations = 1 

// queries to run.
val queries = tpcds.tpcds2_4Queries

// timeout per query, in seconds.
val timeout = 7200
 
//run experiment
val experiment = tpcds.runExperiment(queries, iterations = iterations,resultLocation = resultLocation,forkThread = true)

// wait for finish
experiment.waitForFinish(timeout)

EOF
