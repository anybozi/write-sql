工单编号	XQGZ2024110600212	需求标题	需要从CRM上导出广州铜线宽带用户清单	需求关键词	铜线宽带
提交人	李映亚	提交人电话	13316026456,02083822961	提交部门	广东公司/市分公司/广州分公司/综合维护优化中心/国际通信中心/核心网运营团队
提交日期	2024-11-06 09:45:04	需求负责人	
需求内容
涉及范围	分公司个性需求	是否影响客户感知	不影响	IT前向嵌入人员	
需求分类	产品支撑类需求(B类)-宽带多媒体类	要求独立测试报告	否
首要系统	业务支持系统(BSS)-新一代 CRM3.0	工作总量	0
相关系统		系统模块	
期望完成时间	2024-11-20 00:00:00	计划完成时间		需求重要程度	中
实现方式		实施紧急程度	一般
退回原因		满意度		是否专项需求	
系统模块		影响用户数		影响单量	
业务风险		同类/历史工单单号		是否灰度验证测试	
系统类型		业务分类	
需求描述	根据分公司云网部的要求，为进一步推进网络简化工作，需要从CRM上统计铜线宽带用户清单。清单包含以下字段：产品名称、号码/账号、多媒体账号、外线方式、状态，具体见附件模版。

已通过<市公司内部提取批量用户信息>流量审批，审批截图见附件。
需求目标	从CRM导出广州铜线宽带用户清单


需求梳理：提取2024年11月在网铜线宽带用户的产品名称、号码/账号、多媒体账号、外线方式、状态
要求：锁定外线方式为'ALT002','ALT004','ALT011','ALT020'且在网的号码


输出字段：
产品名称、接入号、多媒体账号、外线方式、状态


--查找铜线宽带用户号码
drop table if exists zone_gz_yz.tmp_yz_xy_XQGZ2024110600212_01 purge;
create table zone_gz_yz.tmp_yz_xy_XQGZ2024110600212_01
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')        
as
select product_id,acc_nbr,acc_nbr2,
case
when fttx_type = 'ALT004' then '独有LAN'
when fttx_type = 'ALT002' then '独有电话线'
when fttx_type = 'ALT011' then 'LAN小区'
when fttx_type = 'ALT020' then 'FTTB+DSL' 
else '其他' end as fttx_type,
state
from dwm_yz_tb_comm_cm_all_final
where fttx_type in ('ALT002','ALT004','ALT011','ALT020') and par_month_id =202411 and prod_type=40 and is_cancel_user=0
--1238


--取产品名称
drop table if exists zone_gz_yz.tmp_yz_xy_XQGZ2024110600212_02 purge;
create table zone_gz_yz.tmp_yz_xy_XQGZ2024110600212_02
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')        
as
select b.prod_name,a.acc_nbr,a.acc_nbr2,a.fttx_type,a.state
from tmp_yz_xy_XQGZ2024110600212_01 a
left join dws_crm_cfguse.dws_product b
on a.prod_id=b.prod_id
--1238

--取状态
drop table if exists zone_gz_yz.tmp_yz_xy_XQGZ2024110600212_03 purge;
create table zone_gz_yz.tmp_yz_xy_XQGZ2024110600212_03
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')        
as
select a.prod_name,a.acc_nbr,a.acc_nbr2,a.fttx_type,b.attr_value_name
from tmp_yz_xy_XQGZ2024110600212_02 a
left join dws_crm_cfguse.dws_attr_value b
on a.state=b.attr_value and b.city_id='200' and b.attr_id='4000000201'
--1238

drop table if exists zone_gz_yz.ads_tmp_yz_xy_XQGZ2024110600212 purge;
create table zone_gz_yz.ads_tmp_yz_xy_XQGZ2024110600212
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')        
as
select * from tmp_yz_xy_XQGZ2024110600212_03

--建立视图
drop view if exists zone_gz.view_ads_tmp_yz_xy_XQGZ2024110600212;
create view if not exists zone_gz.view_ads_tmp_yz_xy_XQGZ2024110600212
(
,prod_name               comment '产品名称'
,acc_nbr             comment '号码/账号'
,acc_nbr2                  comment '多媒体账号'
,fttx_type                  comment '外线方式'
,attr_value_name               comment '状态'
)
as
select
prod_name             
,acc_nbr            
,acc_nbr2             
,fttx_type               
,attr_value_name        
from zone_gz_yz.ads_tmp_yz_xy_XQGZ2024110600212;