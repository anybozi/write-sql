工单编号	XQGZ2026052802368	需求标题	关于批量导出退网产品接入号及出账信息的需求	需求关键词	批量导数
提交人	李蕴怡	提交人电话	18122366668,02038806917	提交部门	广东公司/市分公司/广州分公司/政企客户部/双线跨域团队
提交日期	2026-05-28 17:34:16	需求负责人	
需求内容
涉及范围	分公司个性需求	是否影响客户感知	不影响	IT前向嵌入人员	
需求分类	业务数据处理类需求(E类)-业务数据修正	要求独立测试报告	否
首要系统	业务支持系统(BSS)-客户关系管理系统-CRM门户	工作总量	0
相关系统		系统模块	
期望完成时间	2026-05-29 00:00:00	计划完成时间		需求重要程度	低
实现方式		实施紧急程度	一般
退回原因		满意度		是否专项需求	
系统模块		影响用户数		影响单量	
业务风险		同类/历史工单单号		是否灰度验证测试	
系统类型		业务分类	
需求描述	近期全省开展双线业务群腐整治行动，其中涉及BO域一致性稽核，客资中心发来邮件，附件中为1890条基础网业务，其中大部分属于停机状态，该部分业务CRM有资料，资源系统无，且网络已退网，建议拆机清理。
因客资中心仅提供群号，未提供群组下的A、B端号码，请业支协助批量导出同组下A、B端接入号及4月账期出账，若确认为0后续需要批量拆机清理。

请业支导出附件标黄列。
需求目标	批量导数

--
需求梳理：1.根据需求方提供的群端接入号，匹配AB端号码，即号码有主从AZ关系
2.从划小收入清单匹配号码4月税前出账a1_sq+a5_sq

--导入需求方提供的号码
drop table tmp_XQGZ2026052802368;
create table tmp_XQGZ2026052802368
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy') as
select index4 acc_nbr
from zone_gz_yz_3392082398668800
;

--匹配群端号码服务标识
drop table tmp_XQGZ2026052802368_1;
create table tmp_XQGZ2026052802368_1
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy') as
select a.*,b.serv_id
from tmp_XQGZ2026052802368 a
left join (select serv_id,acc_nbr from dwm_yz_tb_comm_cm_all_final where par_month_id=202606) b on a.acc_nbr=b.acc_nbr
;

--从dws_crm_cust.dws_prod_inst_rel_a和dws_crm_cust.dws_prod_inst_rel_grp_a两个AZ端关系表找到所有Z端服务标识
drop table tmp_XQGZ2026052802368_2;
create table tmp_XQGZ2026052802368_2
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy') as
select a_prod_inst_id,z_prod_inst_id 
from dws_crm_cust.dws_prod_inst_rel_a --产品关联口径
where city_id='200'
and a_prod_inst_id in (select serv_id from tmp_XQGZ2026052802368_1)
union all
select a_prod_inst_id,z_prod_inst_id 
from dws_crm_cust.dws_prod_inst_rel_grp_a --业务关联口径
where city_id='200'
and a_prod_inst_id in (select serv_id from tmp_XQGZ2026052802368_1)
;

--排序区分AB端
drop table tmp_XQGZ2026052802368_3;
create table tmp_XQGZ2026052802368_3
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy') as
select a_prod_inst_id,z_prod_inst_id,row_number() over(partition by a_prod_inst_id order by z_prod_inst_id) px
from (select distinct a_prod_inst_id,z_prod_inst_id from tmp_XQGZ2026052802368_2) a
;
--皮
drop table tmp_XQGZ2026052802368_4;
create table tmp_XQGZ2026052802368_4
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy') as
select a.*,b.z_prod_inst_id serv_id_a,c.z_prod_inst_id serv_id_b
from tmp_XQGZ2026052802368_1 a
left join tmp_XQGZ2026052802368_3 b on a.serv_id=b.a_prod_inst_id and b.px=1
left join tmp_XQGZ2026052802368_3 c on a.serv_id=c.a_prod_inst_id and c.px=2
;

--匹配AB端接入号
drop table tmp_XQGZ2026052802368_5;
create table tmp_XQGZ2026052802368_5
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy') as
select a.*,b.acc_nbr acc_nbr_a,c.acc_nbr acc_nbr_b
from tmp_XQGZ2026052802368_4 a
left join (select serv_id,acc_nbr from dwm_yz_tb_comm_cm_all_final where par_month_id=202606) b on a.serv_id_a=b.serv_id
left join (select serv_id,acc_nbr from dwm_yz_tb_comm_cm_all_final where par_month_id=202606) c on a.serv_id_b=c.serv_id
;

--取税前出账收入
drop table tmp_XQGZ2026052802368_6;
create table tmp_XQGZ2026052802368_6
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy') as
select serv_id,sum(a1_sq+a5_sq) fee from dwm_srhx_serv_list_mon_final where par_month_id=202604 group by serv_id
;

--匹配到三端号码
drop table tmp_XQGZ2026052802368_7;
create table tmp_XQGZ2026052802368_7
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy') as
select a.*,b.fee,c.fee fee_a,d.fee fee_b
from tmp_XQGZ2026052802368_5 a
left join tmp_XQGZ2026052802368_6 b on a.serv_id=b.serv_id
left join tmp_XQGZ2026052802368_6 c on a.serv_id_a=c.serv_id
left join tmp_XQGZ2026052802368_6 d on a.serv_id_b=d.serv_id
;