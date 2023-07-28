# Run Spark with docker compose

Start cluster and run:

`docker compose up -d`

shutdown:

`docker compose down --remove-orphans`

run with multiple workers:

`docker-compose up -d --scale spark-worker=3`
