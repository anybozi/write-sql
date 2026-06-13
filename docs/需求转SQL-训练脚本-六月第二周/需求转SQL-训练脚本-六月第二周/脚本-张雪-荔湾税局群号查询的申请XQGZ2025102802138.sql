【工单详情】
工单编号	XQGZ2025102802138	
需求标题	荔湾税局群号查询的申请
提交人	张雪	提交人电话	18902226612,02085605952	提交部门	广东公司/市分公司/广州分公司/政企客户部/临-外部组织/临-政务行业团队
提交日期	2025-10-28 17:02:00
需求描述	目的：荔湾税局税局提取客编3020018716300000和3020038957740000名下的汇线通群，并提取群号下面的号码和对应短号短号，用于核对工作需求。
频次：一次性
数据销毁：由客户经办人张雪操作，并由直线经理陈秋燕监督方式，进行双人模式监督销毁，确保不留存。

【取数口径】
锁定202510统计月产权客户编码3020018716300000和3020038957740000名下的汇线通群（含在网或当月拆机），并提取群号下面的号码和对应短号短号

【输出字段】
'服务标识','接入号','产权客户编码','汇线通群号','汇线通短号'




###################
--###插入 最新时点 指定客户编码下的汇线通号码清单
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025102802138_1;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025102802138_1 as
select distinct 
a.serv_id
,a.acc_nbr
,a.cust_name
,a.cust_nbr
,a.prod_id
,b.prod_name
from zone_gz_yz.dwm_yz_tb_comm_cm_all_final a
left join dws_crm_cfguse.dws_product b on a.prod_id=b.prod_id
where a.par_month_id=202510 
and a.cust_nbr in ('3020018716300000','3020038957740000')
and a.prod_id=3
;

--###更新 汇线通群的服务编码
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025102802138_2;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025102802138_2 as
select
a.*
,b.a_prod_inst_id   --汇线通群服务编码
,b.z_prod_inst_id
from zone_gz_yz.tmp_yz_cqh_XQGZ2025102802138_1 a
left join dws_crm_cust.dws_prod_inst_rel_grp_a b on a.serv_id = b.z_prod_inst_id
;

--###更新 汇线通群号
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025102802138_3;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025102802138_3 as
select
a.*
,b.acc_nbr as acc_nbr_cen   --汇线通群号
from zone_gz_yz.tmp_yz_cqh_XQGZ2025102802138_2 a
left join zone_gz_yz.dwm_yz_tb_comm_cm_all_final b on a.a_prod_inst_id=b.serv_id and b.par_month_id=202510 
;

--###更新 汇线通群内短号
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025102802138_4;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025102802138_4 as
select
a.*
,b.attr_id
,b.attr_value1  --汇线通群内短号
from zone_gz_yz.tmp_yz_cqh_XQGZ2025102802138_3 a
left join summary_ods_day_city.rpt_comm_cm_prod_attr b on a.serv_id=b.serv_id and b.attr_id=104
;

--#####【生成结果清单】
drop table if exists zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025102802138;
create table zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025102802138 as
select 
row_number() over (order by serv_id) as order_id  --序号
,a.*
from zone_gz_yz.tmp_yz_cqh_XQGZ2025102802138_4 a
order by acc_nbr_cen,serv_id
;

--#####【创建赋权需求方的视图】
drop view if exists zone_gz.view_ads_yz_cqh_tmp_XQGZ2025102802138;
create view if not exists zone_gz.view_ads_yz_cqh_tmp_XQGZ2025102802138 
(
serv_id                     comment '服务标识'
,acc_nbr                    comment '接入号'
,cust_nbr                   comment '产权客户编码'
,acc_nbr_cen                comment '汇线通群号'
,attr_value1                comment '汇线通短号'
)
as
select
serv_id
,acc_nbr
,cust_nbr
,acc_nbr_cen
,attr_value1
from zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025102802138
;
