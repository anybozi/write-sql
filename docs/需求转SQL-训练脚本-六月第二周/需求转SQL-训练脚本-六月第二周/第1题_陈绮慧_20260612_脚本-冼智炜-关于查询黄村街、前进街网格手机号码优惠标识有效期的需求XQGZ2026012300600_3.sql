【工单详情】
工单编号	XQGZ2026012300600	
需求标题	关于查询黄村街、前进街网格手机号码优惠标识有效期的需求
提交人	冼智炜	提交人电话	18988933939,02039911616	提交部门	广东公司/市分公司/广州分公司/黄埔分公司/黄埔金融城政商营销服务中心/团队负责人
提交日期	2026-01-23 10:59:56
需求描述	兹有“广州市天河区人民政府黄村街道办事处”、“广州市天河区人民政府前进街道办事处”为黄埔金融城政商营服的名单制客户，均在用我司网格手机合约业务，并于3月到期，为了更好地洽谈续约事宜，申请导到该批号码所有销售品标识的生效时间及结束时间，避免虚增费用，请协助处理，谢谢。

【取数口径】
锁定由需求方提供的号码清单，并提取该批号码已办理（含已过期但crm仍有销售品标识的）的所有销售品编码、销售品名称、生效时间及失效时间

【输出字段】
'序号','黄村街/前进街(根据需求附件名)','街道内号码序号(需求方提供)','服务标识','接入号(需求方提供)','已办理销售品编码','已办理销售品名称','已办理销售品生效时间','已办理销售品失效时间'


--##导入需求方提供的号码清单		
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2026012300600_0;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2026012300600_0 as
select 
current_date() as run_date,
index1 as item_name,
index2 as order_id,
index3 as acc_nbr
from zone_gz_yz.zone_gz_yz_342
;

--##更新 最新统计月的 serv_id		
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2026012300600_1;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2026012300600_1 as
select
a.*
,b.serv_id
,b.open_date as open_date_acc
,date_format(b.open_date,'yyyyMM') as rw_month
,b.cust_name
,b.cust_nbr
from zone_gz_yz.tmp_yz_cqh_XQGZ2026012300600_0 a
left join (select distinct serv_id,acc_nbr,to_date(open_date) as open_date,cust_name,cust_nbr
           from zone_gz_yz.dwm_yz_tb_comm_cm_all_final
           where par_month_id=202601) b on a.acc_nbr=b.acc_nbr
where 1=1
;

--##插入 最新时点 目标号码办理所有销售品实例清单(从优惠资料表)		
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2026012300600_2;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2026012300600_2 as
select 
a.*
,b.prod_offer_id
,b.prod_offer_code
,b.offer_name as prod_offer_name
,b.msobjgrp_id
,to_date(b.open_date) as open_date
,to_date(b.limit_date) as limit_date
,date_format(b.limit_date,'yyyyMM') as limit_month
from zone_gz_yz.tmp_yz_cqh_XQGZ2026012300600_1 a
left join (select x.serv_id,x.acc_nbr,x.msobjgrp_id,x.open_date,x.limit_date,x.prod_offer_id,y.prod_offer_code,y.offer_name
           from summary_ods_day_city.rpt_comm_cm_msdisc x
           join dws_crm_cfguse.dws_offer y on x.prod_offer_id=y.offer_id and y.city_id=200
           ) b on a.serv_id=b.serv_id
where 1=1
;

--##生成结果清单		
drop table if exists zone_gz_yz.ads_yz_cqh_tmp_XQGZ2026012300600;
create table zone_gz_yz.ads_yz_cqh_tmp_XQGZ2026012300600 as
select 
row_number() over (order by serv_id) as order_id1  --序号
,a.*
from zone_gz_yz.tmp_yz_cqh_XQGZ2026012300600_2 a
where 1=1
;
"
beeline -e "$hql" 

--##创建视图		
drop view if exists zone_gz.view_ads_yz_cqh_tmp_XQGZ2026012300600;
create view if not exists zone_gz.view_ads_yz_cqh_tmp_XQGZ2026012300600 
(
order_id1         comment '序号'
,item_name        comment '黄村街/前进街(根据需求附件名)'
,order_id         comment '街道内号码序号(需求方提供)'
,serv_id          comment '服务标识'
,acc_nbr          comment '接入号(需求方提供)'
,prod_offer_code  comment '已办理销售品编码'
,prod_offer_name  comment '已办理销售品名称'
,open_date        comment '已办理销售品生效时间'
,limit_date       comment '已办理销售品失效时间'
)
as
select
order_id1
,item_name
,order_id
,serv_id
,acc_nbr
,prod_offer_code
,prod_offer_name
,open_date
,limit_date
from zone_gz_yz.ads_yz_cqh_tmp_XQGZ2026012300600
;