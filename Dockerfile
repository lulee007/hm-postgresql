FROM mdillon/postgis
LABEL AUTHOR="xhlu <xhlu@handsmap.cn>"

RUN apt-get update && \
    apt-get install -y \
    postgresql-server-dev-11 \
    libpq-dev \
    build-essential \
    alien \
    mysql-client \
    default-libmysqlclient-dev \
    wget \
    zip \
    make && \
    rm -rf /var/lib/apt/lists/*

# RUN ls /var/lib/postgresql/data

RUN mkdir -p /docker-entrypoint-initdb.d

# mysql
ADD ./mysql_fdw-master.zip /opt/
RUN cd /opt/ && unzip ./mysql_fdw-master.zip && \
    rm -rf /opt/mysql_fdw-master.zip

# oracle 
ADD ./*.rpm /opt/oracle/
ADD ./oracle_fdw-2.2.0.zip /opt/
RUN cd /opt/ && unzip ./oracle_fdw-2.2.0.zip && \
    rm -rf /opt/oracle_fdw-2.2.0.zip.zip


RUN ls /opt -l && ls /opt/mysql_fdw-master/ -l && ls /opt/oracle_fdw-2.2.0/ -l

RUN cd /opt/mysql_fdw-master && \
    make USE_PGXS=1 && \
    make USE_PGXS=1 install

RUN cd /opt/oracle/ && \
    alien -i oracle-instantclient19.3-basic-19.3.0.0.0-1.x86_64.rpm && \
    alien -i oracle-instantclient19.3-devel-19.3.0.0.0-1.x86_64.rpm && \
    rm -rf *.rpm

# 需要修改 oracle_fdw makefile 文件 DOCS = README.oracle 改为 DOCS = README.md
RUN cd /opt/oracle_fdw-2.2.0 && \
    make && \
    make install

RUN cp /usr/lib/oracle/19.3/client64/lib/libclntsh.so.19.1 /usr/lib && \
    cp /usr/lib/oracle/19.3/client64/lib/libnnz19.so /usr/lib

ENV ORACLE_HOME "/usr/lib/oracle/19.3/client64"
ENV LD_LIBRARY_PATH "/usr/lib/oracle/19.3/client64/lib:/usr/lib/oracle/19.3/client64"

VOLUME [ "/var/lib/postgresql/data" ]

RUN apt-get purge --auto-remove alien build-essential make zip wget -y && \
    apt-get clean
# PGDATA:/var/lib/postgresql/data/
# docker run --restart=always -d --name hm-pg -e POSTGRES_PASSWORD=xxxx -p 5432:5432 -v `pwd`/pg_data:/var/lib/postgresql/data handsmap/postgresql.11.2:1.0.0
# docker restart hmgis-postgres-2
# docker cp postgresql.conf hmgis-postgres-2:/var/lib/postgresql/data/postgresql.conf
# docker build -t handsmap/postgresql.11.2:1.0.0 .