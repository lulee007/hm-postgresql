# hm/postgresql

- 添加 mysql 扩展
- 添加 oracle 扩展
- 挂载 data 目录
- 修改默认日志 mod

## 构建

1. 下载源码

   ```sh
   git clone https://github.com/lulee007/hm-postgresql.git
   ```

   **注意:**

   - oracle_fdw-2.2.0.zip `oracle_fdw-2.2.0.zip` 文件中的 `Makefile` 文件内容: `DOCS = README.oracle_fdw` 已经修改为 `DOCS = README.md`,从官网下载的原始压缩包不对
   - [mysql_fdw-master.zip](https://github.com/EnterpriseDB/mysql_fdw.git) Latest commit 5974209 on 28 Sep 2019

2. 构建

   ```sh
   docker build -t handsmap/postgresql.11.2:1.0.0 .
   ```

3. 运行

   ```sh
   docker run --restart=always -d --name hm-pg -e POSTGRES_PASSWORD=xxxx -p 5432:5432 -v `pwd`/pg_data:/var/lib/postgresql/data handsmap/postgresql.11.2:1.0.0
   ```

   **注意:** `pwd` 需要改为实际路径,`xxxx` 也需要改为实际密码

---

## 参考 mdillon/postgis

[![Build Status](https://travis-ci.org/appropriate/docker-postgis.svg)](https://travis-ci.org/appropriate/docker-postgis) [![Join the chat at https://gitter.im/appropriate/docker-postgis](https://badges.gitter.im/Join%20Chat.svg)](https://gitter.im/appropriate/docker-postgis?utm_source=badge&utm_medium=badge&utm_campaign=pr-badge&utm_content=badge)

The `mdillon/postgis` image provides a Docker container running Postgres with [PostGIS 2.5](http://postgis.net/) installed. This image is based on the official [`postgres`](https://registry.hub.docker.com/_/postgres/) image and provides variants for each version of Postgres 9 supported by the base image (9.4-9.6), Postgres 10, and Postgres 11.

This image ensures that the default database created by the parent `postgres` image will have the following extensions installed:

- `postgis`
- `postgis_topology`
- `fuzzystrmatch`
- `postgis_tiger_geocoder`

Unless `-e POSTGRES_DB` is passed to the container at startup time, this database will be named after the admin user (either `postgres` or the user specified with `-e POSTGRES_USER`). If you would prefer to use the older template database mechanism for enabling PostGIS, the image also provides a PostGIS-enabled template database called `template_postgis`.

## Usage

In order to run a basic container capable of serving a PostGIS-enabled database, start a container as follows:

    docker run --name some-postgis -e POSTGRES_PASSWORD=mysecretpassword -d mdillon/postgis

For more detailed instructions about how to start and control your Postgres container, see the documentation for the `postgres` image [here](https://registry.hub.docker.com/_/postgres/).

Once you have started a database container, you can then connect to the database as follows:

    docker run -it --link some-postgis:postgres --rm postgres \
        sh -c 'exec psql -h "$POSTGRES_PORT_5432_TCP_ADDR" -p "$POSTGRES_PORT_5432_TCP_PORT" -U postgres'

See [the PostGIS documentation](http://postgis.net/docs/postgis_installation.html#create_new_db_extensions) for more details on your options for creating and using a spatially-enabled database.

## Known Issues / Errors

When You encouter errors due to PostGIS update `OperationalError: could not access file "$libdir/postgis-X.X`, run:

`docker exec some-postgis update-postgis.sh`

It will update to Your newest PostGIS. Update is idempotent, so it won't hurt when You run it more than once, You will get notification like:

    ```sh
    Updating PostGIS extensions template_postgis to X.X.X
    NOTICE:  version "X.X.X" of extension "postgis" is already installed
    NOTICE:  version "X.X.X" of extension "postgis_topology" is already installed
    NOTICE:  version "X.X.X" of extension "postgis_tiger_geocoder" is already installed
    ALTER EXTENSION
    Updating PostGIS extensions docker to X.X.X
    NOTICE:  version "X.X.X" of extension "postgis" is already installed
    NOTICE:  version "X.X.X" of extension "postgis_topology" is already installed
    NOTICE:  version "X.X.X" of extension "postgis_tiger_geocoder" is already installed
    ALTER EXTENSION
    ```
