#ベースはCentOS7
FROM centos:centos7

#あらかじめPostgreSQLのソースを配置しておく
COPY postgresql-10.5.tar.gz /usr/local/src

### 以下PostgreSQLのインストール ###

#必要なライブラリ等をインストール
RUN yum -y install gcc \
  && yum -y install make \
  && yum -y install readline \
  && yum -y install readline-devel \
  && yum -y install wget \
  && yum -y install zlib-devel

#ユーザ作成
RUN useradd postgres

#インストールディレクトリ作成
RUN mkdir /usr/local/pgsql \
  && chown postgres:postgres /usr/local/pgsql \
  && chmod 755 /usr/local/pgsql

#postgresユーザにスイッチ
USER postgres
WORKDIR /home/postgres

#インストール
#RUN wget https://ftp.postgresql.org/pub/source/v10.5/postgresql-10.5.tar.gz \
RUN tar zxvf /usr/local/src/postgresql-10.5.tar.gz \
  && cd postgresql-10.5/ \
  && ./configure --prefix=/usr/local/pgsql \
  && make \
  && make install

#データベースクラスタを作成する
RUN /usr/local/pgsql/bin/initdb --encoding=UTF8 --no-locale -D /usr/local/pgsql/data

# rootユーザおよびデータベース「my_db」を作成する
RUN /usr/local/pgsql/bin/pg_ctl -D /usr/local/pgsql/data -w start \
  && /usr/local/pgsql/bin/psql --command "CREATE USER root WITH SUPERUSER PASSWORD 'docker';" \
  && /usr/local/pgsql/bin/createdb my_db root 

#外部から接続できるように設定を変更
RUN echo "host all  all    0.0.0.0/0  password" >> /usr/local/pgsql/data/pg_hba.conf

#すべてのIPアドレスからの接続を許可
RUN echo "listen_addresses='*'" >> /usr/local/pgsql/data/postgresql.conf

#PORT開放
EXPOSE 5432

#フォアグラウンドで実行
CMD ["/usr/local/pgsql/bin/postgres", "-D", "/usr/local/pgsql/data/"]

