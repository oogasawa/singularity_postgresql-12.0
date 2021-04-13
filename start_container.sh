#!/bin/bash

DATABASE_HOME="${HOME}/database"
IMAGE_PATH="${HOME}/sing/singularity_postgresql.sif"
INSTANCE_NAME="pgsql_instance"
PORT="55432"

# instance起動
singularity instance start \
-B ${DATABASE_HOME}/data:/usr/local/pgsql/data \
-B ${DATABASE_HOME}/logs:/usr/local/pgsql/logs \
${IMAGE_PATH} ${INSTANCE_NAME}

# postgresqlサーバ起動
singularity exec instance://${INSTANCE_NAME} pg_ctl -D /usr/local/pgsql/data -l /usr/local/pgsql/logs/logfile -o "-p ${PORT}" start
