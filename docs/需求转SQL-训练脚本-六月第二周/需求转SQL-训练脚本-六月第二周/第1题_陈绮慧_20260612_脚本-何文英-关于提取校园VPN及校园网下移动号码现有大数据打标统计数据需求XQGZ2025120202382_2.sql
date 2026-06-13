【工单详情】
工单编号	XQGZ2025120202382	
需求标题	关于提取校园VPN及校园网下移动号码现有大数据打标统计数据需求
提交人	何文英	提交人电话	13316008488,	提交部门	广东公司/市分公司/广州分公司/黄埔分公司/临-外部组织/临-黄埔教育BU营销服务中心
提交日期	2025-12-02 17:40:59
需求描述	为支撑黄埔校园存量客户经营需要，现申请1、提取校园VPN（群号009310050680）；2、现申请提取广州航海学院及广州商学院过往至今的入网并在用清单，该学校网点编码：航海4401123894884、4401122765323、广商4401123974981；以上二个需求的移动号码的所有现有标签的统计数据（包括根据入网年限区分的所有标签、具体打标数量以及占比信息、包括：爱游戏 、爱音乐、爱视频、爱交友、爱网购）；请处理，谢谢。
需求目标	提取黄埔校园VPN及校园网名下移动号码现有大数据打标统计数据

【取数口径】
提取以下两部分清单：
1、提取vpn群号为009310050680，且当前(202512统计月)仍在网的移动号码清单。
2、提取号码揽装网点编码为(4401123894884,4401122765323,4401123974981)，且当前(202512统计月)仍在网的移动号码清单。

【输出字段】
'序号','项目名称','服务标识','移动接入号','移动主套餐名称','在网时长','付费类型','终端注册类型是否5G','202511月开机天数','近三月平均溢出流量收入','近三个平均出账费用','近三月平均税后确认收入','202511月套餐积分','入网揽装人姓名','划小营服'


--##锁定VPN群号取数插入清单（第一部分清单）
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_0;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_0 as
select distinct 
a.par_month_id as month_id
,a.serv_id
,a.acc_nbr
,to_date(a.open_date) as open_date
,a.prod_id
,a.cust_id
,a.cust_nbr
,a.cust_code
,a.cust_name
,a.payment_id
,case when a.payment_id=1 then '后付费' 
      when a.payment_id=2 then '预付费' 
      else null end as payment_type
,a.subst_id
,a.subst_name
,a.branch_id
,a.branch_name
,a.area_id
,a.area_name
,a.grid_id
,a.grid_code
,a.grid_name
,a.sales_id
,a.sales_name
,a.sales_code
,a.channel_id
,a.channel_nbr
,a.channel_name
,a.channel_type
,a.channel_subst_name
,a.channel_branch_name
,a.vpn_value
,a.vpn_price
,a.online_time
,a.state
,a.cdma_disc_type
,b.cdma_disc_desc
,'1、锁定VPN群号取数' as item_name
from zone_gz_yz.dwm_yz_tb_comm_cm_all_final a
left join metadata_ods_day.md_ft_cdma_disc_config b on a.cdma_disc_type=b.cdma_disc_id
where a.par_month_id=202512
and a.is_cancel_user=0
and a.prod_id in (3204,3205)
and a.vpn_value in ('009310050680')
;

--##锁定揽装网点取数插入清单（第二部分清单）	
insert into zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_0
(
 month_id
,serv_id
,acc_nbr
,open_date
,prod_id
,cust_id
,cust_nbr
,cust_code
,cust_name
,payment_id
,payment_type
,subst_id
,subst_name
,branch_id
,branch_name
,area_id
,area_name
,grid_id
,grid_code
,grid_name
,sales_id
,sales_name
,sales_code
,channel_id
,channel_nbr
,channel_name
,channel_type
,channel_subst_name
,channel_branch_name
,vpn_value
,vpn_price
,online_time
,state
,cdma_disc_type
,cdma_disc_desc
,item_name
)
select distinct 
a.par_month_id as month_id
,a.serv_id
,a.acc_nbr
,to_date(a.open_date) as open_date
,a.prod_id
,a.cust_id
,a.cust_nbr
,a.cust_code
,a.cust_name
,a.payment_id
,case when a.payment_id=1 then '后付费' 
      when a.payment_id=2 then '预付费' 
      else null end as payment_type
,a.subst_id
,a.subst_name
,a.branch_id
,a.branch_name
,a.area_id
,a.area_name
,a.grid_id
,a.grid_code
,a.grid_name
,a.sales_id
,a.sales_name
,a.sales_code
,a.channel_id
,a.channel_nbr
,a.channel_name
,a.channel_type
,a.channel_subst_name
,a.channel_branch_name
,a.vpn_value
,a.vpn_price
,a.online_time
,a.state
,a.cdma_disc_type
,b.cdma_disc_desc
,'2、锁定揽装网点取数' as item_name
from zone_gz_yz.dwm_yz_tb_comm_cm_all_final a
left join metadata_ods_day.md_ft_cdma_disc_config b on a.cdma_disc_type=b.cdma_disc_id
where a.par_month_id=202512
and a.is_cancel_user=0
and a.prod_id in (3204,3205)
and a.channel_nbr in ('4401123894884','4401122765323','4401123974981')
;

--##生成 指定月份202511的 开机天数、套餐积分 打标清单		
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_lbl1;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_lbl1 as
select
a.serv_id
,b.kj_num
,b.rh_tc_value
from zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_0 a
left join (select serv_id,kj_num,rh_tc_value
           from zone_gz_yz.dwm_yz_tb_comm_cm_all_mon_final
           where par_month_id=202511
           group by serv_id,kj_num,rh_tc_value) b on a.serv_id=b.serv_id
;

--##生成 近三个月 平均出账费用、平均税后确认收入 打标清单		
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_lbl2;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_lbl2 as
select
a.serv_id
,b.fee_sum/3 as fee_avg
,b.fee_new_tax_sum/3 as fee_new_tax_avg
from zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_0 a
left join (select serv_id,sum(fee) as fee_sum,sum(fee_new_tax) as fee_new_tax_sum
           from zone_gz_yz.dwm_yz_tb_comm_cm_all_mon_final
           where par_month_id in (202511,202510,202509)
           group by serv_id) b on a.serv_id=b.serv_id
;

--##生成 近三个月 流量溢出 打标清单		
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_lbl3;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_lbl3 as
select
a.serv_id
,b.fee_tcw_sum/3 as fee_tcw_avg
from zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_0 a
join (select serv_id,cast(sum(case when due_income_code in ('SR011202', 'SR021202', 'SR031202') then charge else 0 end) / 100 as decimal(12,2)) as fee_tcw_sum
      from srhx.cld_sure_src_hf 
      where latn='gz' and yyyymm in (202511,202510,202509) and due_income_code in ('SR011202','SR021202','SR031202')
      group by serv_id) b on a.serv_id=b.serv_id
;

--##生成 注册终端类型 打标清单			
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_lbl4;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_lbl4 as
select distinct 
a.serv_id
,b.brand_type
,b.terminal_type
,b.register_time
,case when b.brand_type='5G' then '是' else '否' end as is_5G_brand
from zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_0 a
join (select acc_nbr,brand_type,terminal_type,to_date(register_time) as register_time,
      row_number() over(partition by acc_nbr order by register_time desc) as order_id 
      from summary_ods_day_szx.rpt_terminal_type_new ) b on a.acc_nbr=b.acc_nbr and datediff(a.open_date,b.register_time)>=-30 and b.order_id=1
where 1=1
;

--##整合更新 全部标签字段
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_1;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_1 as
select
a.*
,b1.kj_num
,b1.rh_tc_value
,b2.fee_avg
,b2.fee_new_tax_avg
,b3.fee_tcw_avg
,b4.brand_type
,b4.terminal_type
,b4.register_time
,b4.is_5G_brand
from (select x.*,x.serv_id as serv_id1
      from zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_0 as x) a
left join zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_lbl1 b1 on a.serv_id=b1.serv_id
left join zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_lbl2 b2 on a.serv_id1=b2.serv_id
left join zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_lbl3 b3 on a.serv_id=b3.serv_id
left join zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_lbl4 b4 on a.serv_id1=b4.serv_id
where 1=1
;

--##【生成结果清单：统计日期${stat_day} 统计月份${month_id}】
drop table if exists zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025120202382;
create table zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025120202382 as
select 
row_number() over (order by serv_id) as order_id  --序号
,a.*
from zone_gz_yz.tmp_yz_cqh_XQGZ2025120202382_1 a
;


--##【创建视图语句】
drop view if exists zone_gz.view_ads_yz_cqh_tmp_XQGZ2025120202382;
create view if not exists zone_gz.view_ads_yz_cqh_tmp_XQGZ2025120202382 
(
order_id            comment '序号'
,item_name          comment '项目名称'
,serv_id            comment '服务标识'
,acc_nbr            comment '移动接入号'
,cdma_disc_desc     comment '移动主套餐名称'
,online_time        comment '在网时长'
,payment_type       comment '付费类型'
,is_5G_brand        comment '终端注册类型是否5G'
,kj_num             comment '202511月开机天数'
,fee_tcw_avg        comment '近三月平均溢出流量收入'
,fee_avg            comment '近三个平均出账费用'
,fee_new_tax_avg    comment '近三月平均税后确认收入'
,rh_tc_value        comment '202511月套餐积分'
,sales_name         comment '入网揽装人姓名'
,branch_name        comment '划小营服'
)
as
select
order_id
,item_name
,serv_id
,acc_nbr
,cdma_disc_desc
,online_time
,payment_type
,is_5G_brand
,kj_num
,fee_tcw_avg
,fee_avg
,fee_new_tax_avg
,rh_tc_value
,sales_name
,branch_name
from zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025120202382
;
