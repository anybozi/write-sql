【工单详情】
工单编号	XQGZ2025020601412	
需求标题	荔湾分公司申请提取街道网格号码使用情况明细
提交人	何莉莹	提交人电话	18102662282,	提交部门	广州分公司/荔湾分公司/临-外部组织/临-政企客户部
提交日期	2025-02-06 16:13:27
需求描述	因续约工作需要，申请提取街道网格号码使用情况明细，号码清单及所需字段如附件，请协助处理，谢谢。

【取数口径】
锁定需求方提供的接入号，提取最新统计月的号码使用状态、移动主套餐名称、终端注册信息，以及202410~202412统计月的主叫时长、上网流量、短信条数，并提取该批号码在当前统计月已办理的属于移动续约销售品维表中的终端补贴及话费补贴的所有销售品情况以及销售品相关信息

【输出字段】
'序号','服务标识','接入号(需求方提供)','号码入网时间','产权客户编码(需求方提供)','划小营服','移动主套餐名称','号码价值积分','终端注册机型','号码使用状态','终补/话补销售品编码','终补/话补销售品名称','终补/话补销售品到期时间','202410月主叫时长(分钟)','202411月主叫时长(分钟)','202412月主叫时长(分钟)','202410月上网流量(M)','202411月上网流量(M)','202412月上网流量(M)','202410月短信条数(条)','202411月短信条数(条)','202412月短信条数(条)'


--###导入清单 并将导入的临时表转换字段名及格式后生成新的临时表
set hive.fetch.task.conversion=none;
set hive.auto.convert.join=false;
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412 as
select 
current_date() as run_date,
index2 as acc_nbr
from zone_gz_yz.zone_gz_yz_342
;

--###插入 最新时点 目标号码清单(从中间层大宽表)
set hive.fetch.task.conversion=none;
set hive.auto.convert.join=false;
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_1;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_1 as
select 
b.serv_id,
a.acc_nbr,
b.cust_id,
b.cust_nbr,
b.cust_name,
b.payment_id,
b.cdma_disc_type,
b.open_date,
b.jz_points,
b.tc_points,
b.state,
b.prod_id
from zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412 a
left join zone_gz_yz.dwm_yz_tb_comm_cm_all_final b on a.acc_nbr=b.acc_nbr and b.par_month_id=date_format(current_date(),'yyyyMM') and b.is_cancel_user=0
;


--###更新 号码使用状态、移动主套餐名称
set hive.fetch.task.conversion=none;
set hive.auto.convert.join=false;
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_2;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_2 as
select 
a.*,
case when a.state is null then '已拆机' else b.attr_value_name end as state_desc,
c.cdma_disc_desc    --移动主套餐名称
from zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_1 as a
left join dws_crm_cfguse.dws_attr_value b on a.state=b.attr_value and b.city_id='200' and b.attr_id = '4000000201'  --更新使用状态 
left join metadata_ods_day.md_ft_cdma_disc_config c on a.cdma_disc_type=c.cdma_disc_id   --更新移动主套餐名称
;

--###更新 终端注册信息
set hive.fetch.task.conversion=none;
set hive.auto.convert.join=false;
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_3;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_3 as
select
a.*,
b.terminal_type,
b.brand_type,
b.factory,
b.register_time
from zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_2 a 
left join (select acc_nbr,terminal_type,brand_type,factory,to_date(register_time) as register_time,
           row_number() over(partition by acc_nbr order by register_time desc) as order_id 
           from summary_ods_day_szx.rpt_terminal_type_new) b on a.acc_nbr=b.acc_nbr and datediff(b.register_time,a.open_date)>=-30 and b.order_id=1
;

--###更新 202410~202412 主叫时长、上网流量、短信条数
set hive.fetch.task.conversion=none;
set hive.auto.convert.join=false;
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_4;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_4 as
select 
a.*,
b.mou_call as mou_call_202410,
c.mou_call as mou_call_202411,
d.mou_call as mou_call_202412,
b.stm_data as stm_data_202410,
c.stm_data as stm_data_202411,
d.stm_data as stm_data_202412,
b.mgs_counts as mgs_counts_202410,
c.mgs_counts as mgs_counts_202411,
d.mgs_counts as mgs_counts_202412
from zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_3 as a
left join (select serv_id,mou_call,stm_data,mgs_counts from zone_gz_yz.dwm_yz_tb_comm_cm_all_mon_final where par_month_id=202410) b on a.serv_id=b.serv_id
left join (select serv_id,mou_call,stm_data,mgs_counts from zone_gz_yz.dwm_yz_tb_comm_cm_all_mon_final where par_month_id=202411) c on a.serv_id=c.serv_id
left join (select serv_id,mou_call,stm_data,mgs_counts from zone_gz_yz.dwm_yz_tb_comm_cm_all_mon_final where par_month_id=202412) d on a.serv_id=d.serv_id
;

--###生成 已办理销售品 打标清单
set hive.fetch.task.conversion=none;
set hive.auto.convert.join=false;
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_lbl_1;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_lbl_1 as
select distinct
a.serv_id,
b.prod_offer_id,
b.msobjgrp_id,
to_date(b.create_date) as disc_create_date,
to_date(b.open_date) as disc_open_date,
to_date(b.limit_date) as disc_limit_date,
c.disc_type_dl,   --优惠大类
c.disc_type_xl    --优惠小类
from zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_4 a
join (select distinct serv_id,prod_offer_id,msobjgrp_id,create_date,open_date,limit_date from summary_ods_day_city.rpt_comm_cm_msdisc) b on a.serv_id=b.serv_id
join zone_gz_yz.ads_dim_yz_yd_ydxy_disc_new c on b.prod_offer_id=c.prod_offer_id and c.disc_type_dl in ('终端补贴','话费补贴')
;

--###更新 销售品相关信息
set hive.fetch.task.conversion=none;
set hive.auto.convert.join=false;
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_5;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_5 as
select 
a.*,
b.prod_offer_id,
b.msobjgrp_id,
b.disc_create_date,
b.disc_open_date,
b.disc_limit_date,
b.disc_type_dl,
b.disc_type_xl,
c.prod_offer_code,
c.offer_name as prod_offer_name
from zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_4 a
left join zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_lbl_1 b on a.serv_id=b.serv_id
left join dws_crm_cfguse.dws_offer c on b.prod_offer_id=c.offer_id and c.city_id=200
;

--#####【生成结果清单】
set hive.fetch.task.conversion=none;
set hive.auto.convert.join=false;
drop table if exists zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025020601412;
create table zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025020601412 as
select 
row_number() over (order by serv_id) as order_id  --序号
,a.*
from zone_gz_yz.tmp_yz_cqh_XQGZ2025020601412_5 a
--where prod_id in (3204,3205)
;


--#####【创建赋权需求方视图】
drop view if exists zone_gz.view_ads_yz_cqh_tmp_XQGZ2025020601412;
create view if not exists zone_gz.view_ads_yz_cqh_tmp_XQGZ2025020601412 
(
order_id                    comment '序号'
,serv_id                    comment '服务标识'
,acc_nbr                    comment '接入号(需求方提供)'
,open_date                  comment '号码入网时间'
,cust_nbr                   comment '产权客户编码(需求方提供)'
,branch_name                comment '划小营服'
,cdma_disc_desc             comment '移动主套餐名称'
,jz_points                  comment '号码价值积分'
,terminal_type              comment '终端注册机型'
,state_desc                 comment '号码使用状态'
,prod_offer_code            comment '终补/话补销售品编码'
,prod_offer_name            comment '终补/话补销售品名称'
,disc_limit_date            comment '终补/话补销售品到期时间'
,mou_call_202410            comment '202410月主叫时长(分钟)'
,mou_call_202411            comment '202411月主叫时长(分钟)'            
,mou_call_202412            comment '202412月主叫时长(分钟)'      
,stm_data_202410            comment '202410月上网流量(M)' 
,stm_data_202411            comment '202411月上网流量(M)'   
,stm_data_202412            comment '202412月上网流量(M)'
,mgs_counts_202410          comment '202410月短信条数(条)' 
,mgs_counts_202411          comment '202411月短信条数(条)'   
,mgs_counts_202412          comment '202412月短信条数(条)'                        
)
as
select
order_id
,serv_id
,acc_nbr
,open_date
,cust_nbr
,branch_name
,cdma_disc_desc
,jz_points
,terminal_type
,state_desc
,prod_offer_code
,prod_offer_name
,disc_limit_date
,mou_call_202410
,mou_call_202411
,mou_call_202412
,stm_data_202410
,stm_data_202411
,stm_data_202412
,mgs_counts_202410
,mgs_counts_202411
,mgs_counts_202412
from zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025020601412
;