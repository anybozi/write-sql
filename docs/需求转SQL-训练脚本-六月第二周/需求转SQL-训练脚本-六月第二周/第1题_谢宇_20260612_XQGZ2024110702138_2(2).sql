工单编号	XQGZ2024110702138	需求标题	关于增城华立学院用户核查是否办理校园网宽带的需求	需求关键词	核查 校园网
提交人	钟俊	提交人电话	13316122928,02082644411	提交部门	广东公司/市分公司/广州分公司/增城分公司/政企客户部/教育行业团队
提交日期	2024-11-07 21:18:09	需求负责人	
需求内容
涉及范围	分公司个性需求	是否影响客户感知	不影响	IT前向嵌入人员	
需求分类	业务数据处理类需求(E类)-业务批处理	要求独立测试报告	否
首要系统	业务支持系统(BSS)-新一代 CRM3.0	工作总量	0
相关系统	业务支持系统(BSS)-新一代 CRM3.0	系统模块	
期望完成时间	2024-11-08 00:00:00	计划完成时间		需求重要程度	中
实现方式		实施紧急程度	一般
退回原因		满意度		是否专项需求	
系统模块		影响用户数		影响单量	
业务风险		同类/历史工单单号		是否灰度验证测试	
系统类型		业务分类	
需求描述	增城华立学院的校园网今年改为学校代收费方式，现秋营已经结束，需要和学校核对办理宽带的数量，以便学校根据电信系统办理数结算费用给我方。现学校提供了在学校公众号上缴纳校园网费用的清单（有学生名字和学生身份证号），但该清单有准备退费的用户，现需要支撑通过身份证号核查学生是否有办理我方的校园宽带。
判断是否办理校园宽带的条件是需带有DM0002-A01标识的校园网宽带，参考接入号：0200104676588
请根据附件查询并在附件D列按要求反馈是或否，谢谢
需求目标	核查是否办理校园网


需求梳理：根据附件的客户清单（包含序号，客户名称，身份证号），打标客户名下是否有号码办理了指定的销售品
要求：
1、防止同名客户，同时匹配名称及身份证号
2、客户名下包含多个号码，只要有一个号码办理了指定销售品，就算客户办理，最后按照客户纬度输出
2、包含敏感信息客户名称，最后按照序号输出

输出字段：
序号，是否办理指定销售品

--去销售品维表找prod_code=DM0002-A01的prod_id
select offer_id,offer_name,prod_offer_code
from dws_crm_cfguse.dws_offer
where prod_offer_code='DM0002-A01'

offer_id=5734536


--导入数据
drop table if exists zone_gz_yz.tmp_yz_xy_XQGZ2024110702138_01 purge;
create table zone_gz_yz.tmp_yz_xy_XQGZ2024110702138_01
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')        
as
select index1 as seq,index2 as cust_name,index3 as social_id
from zone_gz_yz_3542196629293056
--4772


--锁客户名称以及身份证号找客户名下的号码
drop table if exists zone_gz_yz.tmp_yz_xy_XQGZ2024110702138_02 purge;
create table zone_gz_yz.tmp_yz_xy_XQGZ2024110702138_02
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')        
as
select a.seq,a.cust_name,a.social_id,b.serv_id
from tmp_yz_xy_XQGZ2024110702138_01 a
left join dwm_yz_tb_comm_cm_all_final b
on b.par_month_id=202411 and b.prod_type=40 and b.is_cancel_user=0
and b.social_id_type=1
and b.social_id =a.social_id and b.cust_name=a.cust_name
--4833


--在订单表找客户号码是否有办理指定的销售品
drop table if exists zone_gz_yz.tmp_yz_xy_XQGZ2024110702138_03 purge;
create table zone_gz_yz.tmp_yz_xy_XQGZ2024110702138_03
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')        
as
select a.*,
case when b.prod_offer_id=5734536 then 1 else 0 end as kd
from tmp_yz_xy_XQGZ2024110702138_02 a
left join dwd_yz_rpt_comm_cm_msdisc_final b
on a.serv_id=b.serv_id 
and b.par_corp_id='200'
--8646


--按照客户汇总打标客户级是否办理销售品
drop table if exists zone_gz_yz.tmp_yz_xy_XQGZ2024110702138_04 purge;
create table zone_gz_yz.tmp_yz_xy_XQGZ2024110702138_04
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')        
as
select seq,cust_name,social_id,
case when sum(kd)>0 then '是' else '否' end as is_kd
from tmp_yz_xy_XQGZ2024110702138_03
group by seq,cust_name,social_id
--4772


drop table if exists zone_gz_yz.ads_tmp_yz_xy_XQGZ2024110702138 purge;
create table zone_gz_yz.ads_tmp_yz_xy_XQGZ2024110702138
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')        
as
select 200 as city_id,seq,is_kd
from tmp_yz_xy_XQGZ2024110702138_04