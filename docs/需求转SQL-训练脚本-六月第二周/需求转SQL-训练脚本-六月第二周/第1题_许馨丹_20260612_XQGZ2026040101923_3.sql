工单编号	XQGZ2026040101923	需求标题	关于提取和赋权设备名称的需求	需求关键词	匹配设备型号
提交人	刘柔柔	提交人电话	13392135300,02083365155	提交部门	广东公司/市分公司/广州分公司/海珠分公司/销售部
提交日期	2026-04-01 17:13:48	需求负责人	
需求内容
涉及范围	分公司个性需求	是否影响客户感知	不影响	IT前向嵌入人员	
需求分类	业务数据处理类需求(E类)-业务批处理	要求独立测试报告	否
首要系统	业务支持系统(BSS)-客户关系管理系统-CRM门户	工作总量	0
相关系统		系统模块	
期望完成时间	2026-04-02 00:00:00	计划完成时间		需求重要程度	低
实现方式		实施紧急程度	一般
退回原因		满意度		是否专项需求	
系统模块		影响用户数		影响单量	
业务风险		同类/历史工单单号		是否灰度验证测试	
系统类型		业务分类	
需求描述	因营销管控需要，申请按附件提取最新299套餐入网订单信息，并补充订单对应设备名称、设备类型字段信息。为满足日常管控需要，申请对新增和存量业务增加对应的设备信息，字段包括附件字段和设备标识、设备名称、设备类型、购买方式、机身号、数量，并赋权区分查询，请领导审批，谢谢。
需求目标	提取和赋权设备名称

--
需求梳理：根据需求方提供的接入号，匹配号码的设备名称、设备类型、购买方式、机身号、数量
设备信息表ads_yz_prod_res_inst_rel_final
字段：设备名称mkt_res_name、设备类型res_type、购买方式property_type_name、机身号eqpt_sn、数量mkt_res_num

--导入需求方提供的服务标识与接入号
drop table tmp_XQGZ2026040101923;
create table tmp_XQGZ2026040101923 as
select index4 serv_id,index5 acc_nbr from zone_gz_yz_3392082398668800
; 

--从设备表取相关接入号信息
drop table tmp_XQGZ2026040101923_01;
create table tmp_XQGZ2026040101923_01 as
select a.*
from ads_yz_prod_res_inst_rel_final a
where serv_id in (select serv_id from tmp_XQGZ2026040101923)
;

--匹配所需信息
drop table ads_XQGZ2026040101923;
create table ads_XQGZ2026040101923 as
select a.serv_id,a.acc_nbr,b.mkt_res_name,res_type,property_type_name,eqpt_sn,mkt_res_num
from tmp_XQGZ2026040101923 a
left join tmp_XQGZ2026040101923_01 b on a.serv_id=b.serv_id
;