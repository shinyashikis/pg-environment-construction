# ベースイメージはcentos7
FROM centos:centos7

# あらかじめPostgreSQLのソースを配置しておく
COPY postgresql-10.5.tar.gz /usr/local/src

# PostgreSQLのインストール
## 必要なライブラリを先にインストール
RUN yum -y install gcc
RUN yum -y install readline
RUN yum -y install readline-devel
RUN yum -y install zlib-devel
RUN yum -y install make
## ユーザ作成＆ディレクトリ作成
RUN useradd postgres
RUN mkdir /usr/local/pgsql
RUN chown postgres:postgres /usr/local/pgsql
RUN chmod 755 /usr/local/pgsql

RUN su - postgres

## コンパイル
RUN tar zxvf /usr/local/src/postgresql-10.5.tar.gz
RUN cd postgresql-10.5/
RUN ./configure --prefix=/usr/local/pgsql
RUN make
RUN make install




