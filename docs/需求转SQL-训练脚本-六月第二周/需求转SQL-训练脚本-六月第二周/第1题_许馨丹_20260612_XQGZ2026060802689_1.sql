工单编号	XQGZ2026060802689	需求标题	关于提取天河属地专线相关信息的需求	需求关键词	专线
提交人	何璐	提交人电话	18022866608,	提交部门	广东公司/市分公司/广州分公司/天河分公司/政企客户部
提交日期	2026-06-08 22:45:59	需求负责人	
需求内容
涉及范围	分公司个性需求	是否影响客户感知	不影响	IT前向嵌入人员	
需求分类	业务数据处理类需求(E类)-业务批处理	要求独立测试报告	否
首要系统	业务支持系统(BSS)-客户关系管理系统-CRM门户	工作总量	0
相关系统		系统模块	
期望完成时间	2026-06-09 00:00:00	计划完成时间		需求重要程度	低
实现方式		实施紧急程度	一般
退回原因		满意度		是否专项需求	
系统模块		影响用户数		影响单量	
业务风险		同类/历史工单单号		是否灰度验证测试	
系统类型		业务分类	
需求描述	因内部专线维系需要，现申请提取天河属地专线号码相关信息，需提取清单及字段要求可见附件标黄列，请领导审批谢谢！
需求目标	提取天河属地专线相关信息

--
需求梳理：1.根据需求方提供的月份、接入号信息，匹配对应月份的客户名、落地营服、落地网格单元名称、月租、速率、揽装人名称、揽装人归属机构、划小分局、划小营服、是否名单制客户、名单制创建时间
2.名单制用何纬斌管控的会更新的名单制清单，不用is_mdz

--导入需求方提供的数据
drop table tmp_XQGZ2026060802689_01;
create table tmp_XQGZ2026060802689_01 as
select index1 par_month_id,index2 prod_desc,index3 acc_nbr,index4 serv_addr_name,cast(index5 as int) px
from zone_gz_yz_3392082398668800
;

--从双线清单匹配号码基础信息
drop table tmp_XQGZ2026060802689_02;
create table tmp_XQGZ2026060802689_02 as
select a.*,b.serv_id,b.cust_name_tm,b.std_branch_name,b.cell_name,b.yz_cs,b.speed_value,b.sales_name,b.channel_subst_name,b.subst_name,b.branch_name
from tmp_XQGZ2026060802689_01 a
left join (select par_month_id,cust_code,serv_id,acc_nbr,std_branch_name,(case when length(cust_name)<2 then cust_name when length(cust_name)=2 then concat(SUBSTR(cust_name,1,1),'*') when length(cust_name)>2 then concat(SUBSTR(cust_name,1,(length(cust_name)-2)),'**') else null end) as cust_name_tm,cell_name,yz_cs,speed_value,sales_name,channel_subst_name,subst_name,branch_name from ads_yz_sx_qlyz_list_all where par_month_id between 202601 and 202605) b on a.par_month_id=b.par_month_id and a.acc_nbr=b.acc_nbr


--名单制清单补充名单制信息
drop table tmp_XQGZ2026060802689_03;
create table tmp_XQGZ2026060802689_03 as
select a.*,b.hk_flag,b.create_date
from tmp_XQGZ2026060802689_02 a
left join ads_yz_mo_ccust_mdz_final b on a.cust_code=b.ccust_code
;

--输出
select * from tmp_XQGZ2026060802689_03