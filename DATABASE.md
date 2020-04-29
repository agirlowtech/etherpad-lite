### Backing up PostgreSQL database

- input : database directory in `/.d/postgresql/datafordumping/data`
- output : sql dump of `${DB_NAME}` database and of all database. Two files for two dumps located at `/.d/postgresql/datafordumping/backups`

It uses environment variables used by `docker-compose.yml` located in the default `.env` file
If you don't have it, here is what's expected : 

```
DB_NAME=databasename
DB_USER=user
DB_PASS=strongpassword
```

Alternatively, you can set the environment variable with any other method of choice as long as they're sourced/loaded when running the docker commands

#### 1. Start postgresql docker container using (in first shell)

```
cd /.d/etherpad-lite
source .env

docker run -it --rm --name "dbtodump" \
-e "POSTGRES_DB=${DB_NAME}" \
-e "POSTGRES_USER=${DB_USER}" \
-e "POSTGRES_PASSWORD=${DB_PASS}" \
-v "/.d/postgresql/datafordumping/data:/var/lib/postgresql/data" \
-v "/.d/postgresql/datafordumping/backups:/backups" \
postgres:12.2-alpine

// PostgreSQL Container should be started and db running
```

#### 2. Dump ${DB_NAME} and other databases in a `.sql` file (in a second shell)

```
cd /.d/etherpad-lite
source .env

// only exports ${DB_NAME}
docker exec -it dbtodump pg_dumpall -c -f "/backups/pg_dumpall_${DB_NAME}_db_`date +%d-%m-%Y"_"%H_%M_%S`.sql" --database ${DB_NAME} -U ${DB_USER} -w

// exports all databases
docker exec -it dbtodump pg_dumpall -c -f "/backups/pg_dumpall_all_db_`date +%d-%m-%Y"_"%H_%M_%S`.sql" -U ${DB_USER} -w
```

#### 3. Restoring (not tested)

```
// for importing ALL databases
cat pg_dumpall_all_db.sql | docker exec -i your-db-container psql -U ${DB_USER}
```

