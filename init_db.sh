#!/bin/bash

DATABASE_HOME="${HOME}/database"
IMAGE_PATH="${HOME}/sing/singularity_postgresql.sif"
INSTANCE_NAME="pgsql_instance"
PORT="55432"

# ログディレクトリの生成
if [ ! -e ${DATABASE_HOME}/logs ]; then
    mkdir -p ${DATABASE_HOME}/logs
fi

# データベースディレクトリの生成・initdbの実行
if [ ! -e ${DATABASE_HOME}/data ]; then
    mkdir -p ${DATABASE_HOME}/data
    singularity instance start \
    -B ${DATABASE_HOME}/data:/usr/local/pgsql/data \
    -B ${DATABASE_HOME}/logs:/usr/local/pgsql/logs \
    ${IMAGE_PATH} ${INSTANCE_NAME}
    singularity exec instance://${INSTANCE_NAME} initdb -D /usr/local/pgsql/data --encoding=UTF-8 --no-locale
    singularity instance stop ${INSTANCE_NAME}

    # 設定ファイルのコピー
    cp ${DATABASE_HOME}/pg_hba.conf ${DATABASE_HOME}/data/
    cp ${DATABASE_HOME}/pg_ident.conf ${DATABASE_HOME}/data/
    cp ${DATABASE_HOME}/postgresql.conf ${DATABASE_HOME}/data/
fi

