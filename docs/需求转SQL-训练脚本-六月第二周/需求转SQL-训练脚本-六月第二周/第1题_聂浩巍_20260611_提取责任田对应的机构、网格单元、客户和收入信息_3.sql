需求原始内容：
非需求单的临时需求

为了做好年度回溯划分认领规则配置和收入测算工作，南沙申请提取当前责任田对应的机构、网格单元、客户和收入信息。

需求梳理：
南沙现责任田+历史责任田-匹配总收入-匹配责任田对应所属机构-根据网格单元+服务分群规则表匹配现责任田对应的网格单元-根据直销规则匹配名单制客户信息

要求：
1.需求方提供的号码级清单中有揽装人编码，但是以防万一揽装人有更新，所以重新匹配揽装人信息；
2.电信员工表dws_crm_cfguse.dws_staff中可能会有历史记录，匹配后要剔重取最新的一条记录。

输出字段：
责任田名称，责任田编码，责任田标识，责任田所属分局，责任田所属营服，责任田所属包区，责任田所属分局ID，责任田所属营服ID，责任田所属包区ID，
责任田23年总收入，责任田23年内9月累计收入，责任田24年内9月累计收入，责任田23年内10月累计收入，责任田24年内10月累计收入，
责任田对应网格单元，责任田对应网格单元编码，责任田对应网格单元ID，网格单元所属分局，网格单元所属营服，网格单元所属包区，
责任田对应直销规则的直销客户名称，责任田对应直销规则的直销客户ID，责任田对应直销规则的客户编码，对应的直销客户经理，对应的直销客户经理工号

--收入表中历史责任田
drop table if exists tmp_ns_grid_sr;
create table if not exists tmp_ns_grid_sr as
select distinct grid_name,grid_code,grid_id,subst_name,branch_name,area_name,subst_id,branch_id,area_id from dwm_srhx_serv_list_mon_final
;
--现全量责任田
drop table if exists tmp_ns_grid_now;
create table if not exists tmp_ns_grid_now as
select distinct grid_name,grid_nbr,grid_id,subst_name,branch_name,area_name,subst_id,branch_id,area_id from ads_yz_grid_list_final where subst_name = '南沙分公司'
;
--责任田合并，为什么要做这一步，是因为收入表里有很早之前的历史责任田，这部分责任田可能被删除导致当前责任田表无记录，所以要合并
drop table if exists tmp_ns_grid_all;
create table if not exists tmp_ns_grid_all as
select grid_name,grid_code,grid_id from tmp_ns_grid_sr
union
select grid_name,grid_nbr,grid_id from tmp_ns_grid_now
;
--按现状态匹配责任田当前所属机构信息
drop table if exists tmp_ns_grid_all_now;
create table if not exists tmp_ns_grid_all_now as
select a.*,b.subst_name,b.branch_name,b.area_name,b.subst_id,b.branch_id,b.area_id from tmp_ns_grid_all a
left join ads_yz_grid_list_final b
on a.grid_id = b.grid_id
;

--取出所有责任田中的号码级收入清单
drop table if exists tmp_ns_grid_sr_list;
create table if not exists tmp_ns_grid_sr_list as
select * from dwm_srhx_serv_list_mon_final
where grid_id in (select grid_id from tmp_ns_grid_all_now) and par_month_id between 202301 and 202410
;

--责任田累计收入清单
drop table if exists tmp_ns_grid_sr_dwb;
create table if not exists tmp_ns_grid_sr_dwb as
select grid_id,
sum(case when par_month_id between 202301 and 202312 then a0 end) a0_2023,
sum(case when par_month_id between 202301 and 202309 then a0 end) a0_202309,
sum(case when par_month_id between 202401 and 202409 then a0 end) a0_202409,
sum(case when par_month_id between 202301 and 202310 then a0 end) a0_202310,
sum(case when par_month_id between 202401 and 202410 then a0 end) a0_202410
from tmp_ns_grid_sr_list where grid_id <> '-1' and grid_id is not null group by grid_id
;

--用责任田id匹配责任田维度收入清单
drop table if exists tmp_ns_grid_all_now_sr;
create table if not exists tmp_ns_grid_all_now_sr as
select a.*,case when b.a0_2023 is not null then b.a0_2023 else 0 end a0_23,
case when b.a0_202309 is not null then b.a0_202309 else 0 end a0_2309,
case when b.a0_202409 is not null then b.a0_202409 else 0 end a0_2409,
case when b.a0_202310 is not null then b.a0_202310 else 0 end a0_2310,
case when b.a0_202410 is not null then b.a0_202410 else 0 end a0_2410
from tmp_ns_grid_all_now a
left join tmp_ns_grid_sr_dwb b
on a.grid_id = b.grid_id
where a.grid_id <> '-1' and a.grid_id is not null
;

--根据网格单元+服务分群规则匹配网格单元
drop table if exists tmp_ns_grid_all_now_sr_gu;
create table if not exists tmp_ns_grid_all_now_sr_gu as
select a.*,b.grid_unit_name,b.grid_unit_code,b.grid_unit_id,b.subst_name_gu,b.branch_name_gu,b.area_name_gu,
c.ccust_name,c.ccust_id,c.ccust_code,c.staff_name,c.staff_id
from tmp_ns_grid_all_now_sr a
left join (select grid_unit_name,grid_unit_code,grid_unit_id,subst_name_gu,branch_name_gu,area_name_gu,grid_id from ads_yz_ggg_rule_list_final 
			where grid_id is not null and grid_unit_id is not null) b
on a.grid_id = b.grid_id
left join dwd_yz_ccust_rule_final c 
on a.grid_id = c.grid_id
;



