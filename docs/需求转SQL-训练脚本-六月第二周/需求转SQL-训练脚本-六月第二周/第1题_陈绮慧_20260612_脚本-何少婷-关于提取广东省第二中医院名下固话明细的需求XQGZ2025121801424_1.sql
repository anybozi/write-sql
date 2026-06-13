【工单详情】
工单编号	XQGZ2025121801424	
需求标题	关于提取广东省第二中医院名下固话明细的需求
提交人	何少婷	提交人电话	18926269929,02083598093	提交部门	广东公司/市分公司/广州分公司/越秀分公司/临-外部组织/临-越秀卫健BU营销服务中心
提交日期	2025-12-18 15:33:45
需求描述	客户名称：广东省第二中医院(广东省中医药工程技术研究院)，客户编码：3020032433250000，请帮忙导出客户名下所有固话明细，包括：地址，属性，套餐，优惠标识，是否直线电话，是否汇线通，是否加入常青树优惠，近半年的出账费用等，谢谢！

【取数口径】
提取产权客户编码为3020032433250000名下的当前（202512统计月）在网的所有固话号码，并匹配该批号码的装机地址及已办理且当前未过期的销售品信息。
其中办理常青树优惠锁定政企部的常青树清单中圈定的销售品范围。

【输出字段】
'序号','统计日期','产权客户编码(需求方提供)','服务标识','接入号','产品名称','装机地址','是否办理常青树套餐','已办理销售品编码','已办理销售品名称','已办理销售品到期时间'


--##插入 产权客户编码为3020032433250000名下固话号码清单(从业务资料表)		
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_1;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_1 as
select distinct
${stat_day} as data_date,
a.par_month_id as month_id,
a.serv_id,
a.acc_nbr,
a.cust_id,
a.cust_nbr,
a.cust_name,
a.ccust_id,
a.cust_code,
a.prod_id,
a.prod_type,
to_date(a.open_date) as open_date,
a.serv_addr_id,
a.state,
b.attr_value_name as state_desc,    --使用状态
c.prod_name
from zone_gz_yz.dwm_yz_tb_comm_cm_all_final a
left join dws_crm_cfguse.dws_attr_value b on a.state=b.attr_value and b.city_id='200' and b.attr_id = '4000000201'  --更新使用状态 
left join dws_crm_cfguse.dws_product c on a.prod_id=c.prod_id
where a.par_month_id=202512
and a.is_cancel_user=0
and a.cust_nbr='3020032433250000'
and a.prod_type=10
;

--##生成 装机地址 打标清单		
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_lbl_1;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_lbl_1 as
select
a.serv_id
,b.addr  
,(case when length(b.addr)<4 then b.addr
  when length(b.addr)=4 then concat(SUBSTR(b.addr,1,1),'*')
  when length(b.addr)>4 then concat(SUBSTR(b.addr,1,(length(b.addr)-4)),'****')
  else null end) as serv_addr_name   --脱敏
from zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_1 a
left join (select distinct id,addr
           from zone_gz_yz.dwd_yz_addr_final 
           where grade=10   --装机地址一般取十级地址的，即锁定grade=10
           ) b on cast(a.serv_addr_id as decimal(24,0))=b.id
;

--##生成 是否办理常青树套餐 打标清单		
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_lbl_2;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_lbl_2 as
select distinct
a.serv_id,
1 as is_cqs
from zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_1 a
join summary_ods_day_city.rpt_comm_cm_msdisc b on a.serv_id=b.serv_id
where b.prod_offer_id in (6850,10560,27839,26754,15142,507,5780,18831,23343,25279,17344,4972,7300,13676,173,14480,18889,29804,15209,23802,29814,5725532,5728916,5729050,5729217,5729220,5729221,5729222,5729225,5729226,5729227,5729243,5729244,5729245,100055824,100025981,100026801)  --需求方提供常青树销售品id锁定
and date_format(b.limit_date,'yyyyMMdd') > 20251223
;

--##更新 装机地址、是否办理常青树套餐		
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_2;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_2 as
select
a.*
,b1.addr  
,b1.serv_addr_name   --脱敏
,case when b2.is_cqs=1 then '是' else '否' end as is_cqs_desc
from zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_1 a
left join zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_lbl_1 b1 on a.serv_id=b1.serv_id
left join zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_lbl_2 b2 on a.serv_id=b2.serv_id
;

--##插入 目标号码办理所有销售品实例清单(从优惠资料表)		
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_3;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_3 as
select 
a.*
,b.prod_offer_id
,b.prod_offer_code
,b.offer_name as prod_offer_name
,b.msobjgrp_id
,to_date(b.limit_date) as limit_date
,date_format(b.limit_date,'yyyyMM') as limit_month
from zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_2 a
left join (select x.serv_id,x.acc_nbr,x.msobjgrp_id,x.open_date,x.limit_date,x.prod_offer_id,y.prod_offer_code,y.offer_name
           from summary_ods_day_city.rpt_comm_cm_msdisc x
           join dws_crm_cfguse.dws_offer y on x.prod_offer_id=y.offer_id and y.city_id=200
           where date_format(x.limit_date,'yyyyMMdd') > 20251223
           ) b on a.serv_id=b.serv_id
where 1=1
;

--##生成结果清单		
drop table if exists zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025121801424;
create table zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025121801424 as
select 
row_number() over (order by serv_id) as order_id  --序号
,'200' as city_id
,a.*
from zone_gz_yz.tmp_yz_cqh_XQGZ2025121801424_3 a
where 1=1
;

--##创建视图		
drop view if exists zone_gz.view_ads_yz_cqh_tmp_XQGZ2025121801424;
create view if not exists zone_gz.view_ads_yz_cqh_tmp_XQGZ2025121801424 
(
order_id          comment '序号'
,data_date        comment '统计日期'
,cust_nbr         comment '产权客户编码(需求方提供)'
,serv_id          comment '服务标识'
,acc_nbr          comment '接入号'
,prod_name        comment '产品名称'
,addr             comment '装机地址'
,is_cqs_desc      comment '是否办理常青树套餐'
,prod_offer_code  comment '已办理销售品编码'
,prod_offer_name  comment '已办理销售品名称'
,limit_date       comment '已办理销售品到期时间'
)
as
select
order_id
,data_date
,cust_nbr
,serv_id
,acc_nbr
,prod_name
,addr
,is_cqs_desc
,prod_offer_code
,prod_offer_name
,limit_date
from zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025121801424
;
