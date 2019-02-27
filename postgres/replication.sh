#!/bin/bash
set -e

if [ $REPLICATION_ROLE = "primary" ]; then
  /usr/local/pgsql/bin/pg_ctl start -D /usr/local/pgsql/data

  # レプリケーション用ユーザ「repl_user」を作成
  /usr/local/pgsql/bin/psql -U postgres -c "CREATE USER repl_user REPLICATION PASSWORD 'replication'"

  # 
  echo "host replication repl_user 127.0.0.1/32 md5" >> /usr/local/pgsql/data/pg_hba.conf 

  # レプリケーション用パラメータ設定
  echo "wal_level = hot_standby" >> /usr/local/pgsql/data/postgresql.conf 
  echo "synchronous_commit = local" >> /usr/local/pgsql/data/postgresql.conf
  echo "archive_mode = on" >> /usr/local/pgsql/data/postgresql.conf
  echo "archive_command = 'cp -i %p /var/lib/pgsql/archive/%f < /dev/null'" >> /usr/local/pgsql/data/postgresql.conf
  echo "max_wal_senders = 3" >> /usr/local/pgsql/data/postgresql.conf
  echo "wal_keep_segments = 16" >> /usr/local/pgsql/data/postgresql.conf
  echo "synchronous_standby_names = 'standby1,standby2'" >> /usr/local/pgsql/data/postgresql.conf

  /usr/local/pgsql/bin/pg_ctl stop -D /usr/local/pgsql/data

elif [ $REPLICATION_ROLE = "standby" ]; then
  /usr/local/pgsql/bin/pg_ctl start -D /usr/local/pgsql/data

  rm -rf /usr/local/pgsql/data

  /usr/local/pgsql/bin/pg_basebackup -h primary -U repl_user -D /usr/local/pgsql/data --xlog --progress --verbose --write-recovery-conf

  # レプリケーション用パラメータ設定
  echo "standby_mode = 'on'" >> /usr/local/pgsql/data/recovery.conf
  echo "primary_conninfo = 'host=primary port=5432 user=repl_user password=replication application_name=standby" >> /usr/local/pgsql/data/recovery.conf
  echo "restore_command = 'scp primary:/var/lib/pgsql/archive/%f " >> /usr/local/pgsql/data/recovery.conf

  echo "hot_standby = on" >> /usr/local/pgsql/data/postgresql.conf

  /usr/local/pgsql/bin/pg_ctl stop -D /usr/local/pgsql/data
fi

#フォアグラウンドでPostgreSQLを起動
/usr/local/pgsql/bin/postgres -D /usr/local/pgsql/data/

