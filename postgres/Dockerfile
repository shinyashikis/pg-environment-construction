#ベースはCentOS7
FROM centos:centos7

#あらかじめPostgreSQLのソースを配置しておく
COPY postgresql-10.5.tar.gz /usr/local/src

### 以下PostgreSQLのインストール ###

#必要なライブラリ等をインストール
RUN yum -y install gcc \
  && yum -y install readline \
  && yum -y install readline-devel \
  && yum -y install zlib-devel \
  && yum -y install make \
  && yum -y install wget

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

#postgresユーザの.bashrcに以下の環境変数を追加
RUN echo "export PATH=/usr/local/pgsql/bin:\$PATH" >> ~/.bashrc \
  && echo "export POSTGRES_HOME=/usr/local/pgsql" >> ~/.bashrc \
  && echo "export PGLIB=\$POSTGRES_HOME/lib" >> ~/.bashrc \
  && echo "export PGDATA=/usr/local/pgsql/data" >> ~/.bashrc \
  && echo "export MANPATH=\"\$MANPATH\":\$POSTGRES_HOME/man" >> ~/.bashrc \
  && echo "export LD_LIBRARY_PATH=\"\$LD_LIBRARY_PATH\":\"\$PGLIB\"" >> ~/.bashrc

#PGDATAで設定したディレクトリを作成する
RUN /usr/local/pgsql/bin/initdb --encoding=UTF8 --no-locale -D /usr/local/pgsql/data

#rootユーザにスイッチ
USER root

#起動スクリプトの設定
RUN cp /home/postgres/postgresql-10.5/contrib/start-scripts/linux /etc/init.d/postgres \
  && chmod 755 /etc/init.d/postgres \
  && chkconfig --add  /etc/init.d/postgres

#DBの起動
CMD /etc/init.d/postgres start && tail -f /dev/null
