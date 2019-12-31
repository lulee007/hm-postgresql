# pg-oracle

```sql
CREATE EXTENSION oracle_fdw;

CREATE SERVER oracle_server
    FOREIGN DATA WRAPPER oracle_fdw
    OPTIONS (dbserver 'dev.handsmap.com:1521/hmORCL');

grant usage on foreign server oracle_server to postgres;

create user mapping for postgres server oracle_server  options(user 'gis_map_scenic_oracle',password 'gis_map_scenic_oracle');

-- auto-generated definition
create  foreign table ORA_TB_BASE_MAP_INFO
(
    WID                  VARCHAR(40) not null,
    VIEW_RESOLUTIONS     VARCHAR(4000),
    VIEW_PIXEL_RATIO     FLOAT,
    VIEW_EXTENT_MIN_X    FLOAT,
    VIEW_EXTENT_MIN_Y    FLOAT,
    VIEW_EXTENT_MAX_X    FLOAT,
    VIEW_EXTENT_MAX_Y    FLOAT,
    VIEW_CENTER_X        FLOAT,
    VIEW_CENTER_Y        FLOAT,
    VIEW_PROJECTION      VARCHAR(255),
    VIEW_MAXZOOM         numeric(11),
    VIEW_MINZOOM         numeric(11),
    VIEW_ZOOM            numeric(11),
    BASE_MAP_URL         VARCHAR(4000),
    BASE_MAP_ORIGIN_X    FLOAT,
    BASE_MAP_ORIGIN_Y    FLOAT,
    BASE_MAP_RESOLUTIONS VARCHAR(4000),
    BASE_MAP_MATRIXIDS   VARCHAR(4000),
    BASE_MAP_TILESIZE_X  numeric(11),
    BASE_MAP_TILESIZE_Y  numeric(11),
    BASE_MAP_MINZOOM     numeric(11),
    REMARK               VARCHAR(255),
    BASE_MAP_NAME        VARCHAR(255),
    OVER_AMAP            int2 default 0,
    SCENIC_RANGE         text,
    UPDATE_TIME          DATE
) server oracle_server  options(schema 'GIS_MAP_SCENIC_ORACLE',table 'TB_BASE_MAP_INFO');


SELECT count(t.*) FROM public.ora_tb_base_map_info t;
```