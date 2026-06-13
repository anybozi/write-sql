【工单详情】
工单编号	XQGZ2025111101793	
需求标题	广州市荔湾中心医院固话号码清单提取的申请
提交人	焦宇	提交人电话	18922129660,	提交部门	广东公司/市分公司/广州分公司/荔湾分公司/荔湾卫健BU营销服务中心
提交日期	2025-11-11 16:33:17
需求描述	广州市荔湾中心医院申请提取2021年1月1日至今新装的固话号码清单，要求包含安装时间、安装地址，请协助提取，谢谢！
客户编码：3200062488860000，参考接入号：81348973
证件号：12440103455359976P
接收清单邮箱：360719471@qq.com

需求反馈：
2025-11-14 11:36:36	提取产权客户编码为3200062488860000名下的目前在网的所有固话号码安装时间及安装地址清单，谢谢！	焦宇

【取数口径】
锁定202511统计月在网，且属于产权客户编码为3200062488860000名下的所有固话号码，并提取固话安装时间及安装地址清单

【输出字段】
'序号','统计日期','产权客户编码(需求方提供)','产品名称','服务标识','接入号','号码竣工时间','装机地址(脱敏)'


--###插入 最新时点 产权客户编码为3200062488860000名下的目前在网的所有固话号码(从业务资料表)		
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025111101793_1;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025111101793_1 as
select distinct
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
where a.par_month_id=202511
and a.is_cancel_user=0
and a.cust_nbr='3200062488860000'
and a.prod_type=10
;

--###更新 装机地址		
drop table if exists zone_gz_yz.tmp_yz_cqh_XQGZ2025111101793_2;
create table zone_gz_yz.tmp_yz_cqh_XQGZ2025111101793_2 as
select
a.*
,b.addr  
,(case when length(b.addr)<4 then b.addr
  when length(b.addr)=4 then concat(SUBSTR(b.addr,1,1),'*')
  when length(b.addr)>4 then concat(SUBSTR(b.addr,1,(length(b.addr)-4)),'****')
  else null end) as serv_addr_name   --脱敏
from zone_gz_yz.tmp_yz_cqh_XQGZ2025111101793_1 a
left join (select distinct id,addr
           from zone_gz_yz.dwd_yz_addr_final 
           --where grade=10   --装机地址一般取十级地址的，即锁定grade=10，更新不到的是因为录入的地址不是十级地址（以上李倩企微解答），经与需求方确认，不需要锁定十级地址打标
           ) b on cast(a.serv_addr_id as decimal(24,0))=b.id
;


--###生成结果清单		
drop table if exists zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025111101793;
create table zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025111101793 as
select 
row_number() over (order by serv_id) as order_id  --序号
,'200' as city_id
,a.*
from zone_gz_yz.tmp_yz_cqh_XQGZ2025111101793_2 a
where 1=1
;


--###创建赋权需求方的视图
drop view if exists zone_gz.view_ads_yz_cqh_tmp_XQGZ2025111101793;
create view if not exists zone_gz.view_ads_yz_cqh_tmp_XQGZ2025111101793 
(
order_id          comment '序号'
,data_date        comment '统计日期'
,cust_nbr         comment '产权客户编码(需求方提供)'
,prod_name        comment '产品名称'
,serv_id          comment '服务标识'
,acc_nbr          comment '接入号'
,open_date        comment '号码竣工时间'
,serv_addr_name   comment '装机地址(脱敏)'
)
as
select
order_id
,data_date
,cust_nbr
,prod_name
,serv_id
,acc_nbr
,open_date
,serv_addr_name
from zone_gz_yz.ads_yz_cqh_tmp_XQGZ2025111101793
; 

