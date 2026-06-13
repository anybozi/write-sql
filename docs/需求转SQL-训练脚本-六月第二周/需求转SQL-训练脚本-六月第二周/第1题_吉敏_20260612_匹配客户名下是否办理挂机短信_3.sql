需求原始内容：
需求方提供号码，匹配当前月是否有办理挂机短信（产品编码：PM_GJDXTCLX）

输出字段：
号码,是否办理挂机短信（产品编码：PM_GJDXTCLX）

--提取资料表信息到临时表
drop table zone_gz_yz.tmp_yz_lw_gjdx_cust;
create table zone_gz_yz.tmp_yz_lw_gjdx_cust
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')     
as
select serv_id,acc_nbr,cust_id,prod_id
from dwm_yz_tb_comm_cm_all_final
where par_month_id=202606;


--导入号码信息并匹配serv_id和cust_id
drop table zone_gz_yz.tmp_yz_lw_gjdx_cust1;
create table zone_gz_yz.tmp_yz_lw_gjdx_cust1
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')     
as
select cast(index1 as int) as row_num,index2 as acc_nbr,b.serv_id,b.cust_id
from zone_gz_yz.zone_gz_yz_343 a
left join
(select serv_id,acc_nbr,cust_id
from zone_gz_yz.tmp_yz_lw_gjdx_cust) b
on a.index2=b.acc_nbr;


--提取办理了挂机短信的客户信息
drop table if exists zone_gz_yz.tmp_yz_lw_gjdx_cust2 purge;
create table zone_gz_yz.tmp_yz_lw_gjdx_cust2
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')        
as
select distinct a.serv_id,b.cust_id
from 
(select distinct serv_id 
from summary_ods_day_city.tb_pre_cm_attr_all
where attr_id=7770
) a
left join
(select serv_id,acc_nbr,cust_id
from zone_gz_yz.tmp_yz_lw_gjdx_cust
) b
on a.serv_id=b.serv_id;


--匹配是否办理了挂机短信
drop table if exists zone_gz_yz.tmp_yz_lw_gjdx_cust3 purge;
create table zone_gz_yz.tmp_yz_lw_gjdx_cust3
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')        
as
select 
a.*,
case when a.serv_id is null then '找不到此号码' 
when b.cust_id is not null then '是' else '否' end as is_gjdx
from zone_gz_yz.tmp_yz_lw_gjdx_cust1 a
left join 
(select distinct cust_id 
from zone_gz_yz.tmp_yz_lw_gjdx_cust2
) b
on a.cust_id=b.cust_id
order by a.row_num;


--输出结果
select row_num,acc_nbr,is_gjdx
from zone_gz_yz.tmp_yz_lw_gjdx_cust3
order by row_num