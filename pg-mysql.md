# pg-mysql

```sql
CREATE EXTENSION mysql_fdw;

-- drop server if exists mysql_server;
CREATE SERVER mysql_server
    FOREIGN DATA WRAPPER mysql_fdw
    OPTIONS (host '192.168.50.101', port '3306');

alter SERVER mysql_server
    OPTIONS  (set host '192.168.50.101');

CREATE USER MAPPING FOR postgres
    SERVER mysql_server
    OPTIONS (username 'root', password 'handsmap123');

CREATE FOREIGN TABLE all_poi_infos(
    wid nchar(60),
    t_name text,
    stars int)
    SERVER mysql_server
    OPTIONS (dbname 'map_sync_data', table_name 'all_poi_infos');

select all_poi.* from (select poi_attr.* from poi
right join  all_poi_infos as poi_attr on poi_attr.wid = poi.wid) as all_poi where all_poi.stars in (1,2,3,6,9,10);

select count(*) from all_poi_infos;

CREATE VIEW view_all_poi_infos AS  select poi_attr.* from poi
right join  all_poi_infos as poi_attr on poi_attr.wid = poi.wid;

select poi_attr.* from poi
right join  all_poi_infos as poi_attr on poi_attr.wid = poi.wid;

select * from view_all_poi_infos where view_all_poi_infos.stars in (1,2,3,6,9,9000);
```