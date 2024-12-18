#!/bin/sh

psql -d "host='$SQL_HOST' dbname='postgres' user='$SQL_ROOT_USER' password='$SQL_ROOT_PASSWORD'" -c "CREATE USER $SQL_CMS_USER WITH PASSWORD '$SQL_CMS_PASSWORD';" || true
psql -d "host='$SQL_HOST' dbname='postgres' user='$SQL_ROOT_USER' password='$SQL_ROOT_PASSWORD'" -c "GRANT CONNECT ON DATABASE $SQL_DATABASE_NAME TO $SQL_CMS_USER;"
psql -d "host='$SQL_HOST' dbname='postgres' user='$SQL_ROOT_USER' password='$SQL_ROOT_PASSWORD'" -c "GRANT CREATE ON DATABASE $SQL_DATABASE_NAME TO $SQL_CMS_USER;"
psql -d "host='$SQL_HOST' dbname='$SQL_DATABASE_NAME' user='$SQL_CMS_USER' password='$SQL_CMS_PASSWORD'" -c "CREATE SCHEMA $SQL_SCHEMA AUTHORIZATION $SQL_CMS_USER;" || true