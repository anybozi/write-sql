
工单编号 XQGZ2024120201520 需求标题 提取2024年11月网格单元宽带用户数需求 需求关键词 2024年11月网格单元对应宽带用户数 
提交人 潘莉莉 提交人电话 18022876566, 提交部门 广东公司/市分公司/广州分公司/客户服务部/临-外部组织/临-服务质控团队 
提交日期 2024-12-02 15:17:37 需求负责人  
需求内容   
涉及范围 分公司个性需求 是否影响客户感知 不影响 IT前向嵌入人员  
需求分类 套餐与营销活动支撑类需求(A类)-宽带多媒体类 要求独立测试报告 否 
首要系统 业务支持系统(BSS)-新一代 CRM3.0 工作总量 0 
相关系统  系统模块  
期望完成时间 2024-12-03 00:00:00  计划完成时间  需求重要程度 低 
实现方式  实施紧急程度 一般 
退回原因  满意度  是否专项需求  
系统模块  影响用户数  影响单量  
业务风险  同类/历史工单单号 XQGZ2024111200604 是否灰度验证测试  
系统类型  业务分类  
需求描述 由于数据分析需要，现提需求提取2024年11月各网格单元网格编码（具体网格单元请详见附件“提取202411网格单元宽带用户数.xlsx”）如下数据：
1、2024年11月各网格单元编码的宽带结算到达数
2、2024年11月各网格单元编码的新装入网的宽带数
3、2024年11月各网格单元编码的移机进入宽带数（指移机迁入对应网格单元的宽带数）
4、2024年11月各网格单元编码的拆机宽带数
【可参考历史需求：工单编号 XQGZ2024111200604】 
需求目标 提取2024年11月网格单元宽带用户数 


需求梳理：
根据附件提供的网格编码，匹配网格202411的主宽到达，主宽入网，主宽拆机，主宽移机数据

要求：
1、移动机号码只看主宽号码，其他类型的号码不纳入统计
2、移机号码以移机前后网格为准，不以移机订单为准，前后网格不一致才纳入统计

输出字段：
网格名称，网格编码，主宽到达，主宽入网，主宽拆机，主宽移机数据

--提取网格11月主宽到达、入网、拆机数据
drop table if exists zone_gz_yz.tmp_yz_xy_XQGZ2024120201520_01 purge;
create table zone_gz_yz.tmp_yz_xy_XQGZ2024120201520_01
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')        
as
select a.index1 as cell_name,a.index2 as cell_code,b.kd_dd202411,b.kd_rw202411,b.kd_cj202411
from zone_gz_yz_3542196629293056 a
left join (
select cell_code,
count(case when is_cancel_user=0 and is_cz=1 then serv_id else null end) as kd_dd202411,
count(case when is_new_user=1 then serv_id else null end) as kd_rw202411,
count(case when is_cancel_user=1 then serv_id else null end) as kd_cj202411
from dwm_yz_tb_comm_cm_all_final 
where par_month_id=202411 
and prod_type=40
and kd_desc='普通宽带'
group by cell_code
) b
on a.index2=b.cell_code
--13249

--取移机订单表中主宽号码，移机订单表没有产品类型字段，需关联大宽表打标
drop table if exists zone_gz_yz.tmp_yz_xy_XQGZ2024120201520_02 purge;
create table zone_gz_yz.tmp_yz_xy_XQGZ2024120201520_02
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')        
as
select a.par_month_id,a.acc_nbr,a.serv_id,a.cell_code,a.cell_code_last
from dwd_yz_rpt_comm_ba_subs_move_final a
join dwm_yz_tb_comm_cm_all_final b
on a.par_month_id=b.par_month_id and a.serv_id=b.serv_id and b.prod_type=40 and b.kd_desc='普通宽带'
where a.par_month_id=202411;


--关联网格编码统计网格移机数量并打标回原清单
drop table if exists zone_gz_yz.tmp_yz_xy_XQGZ2024120201520_03 purge;
create table zone_gz_yz.tmp_yz_xy_XQGZ2024120201520_03
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')        
as
select a.*,b.kd_yj202411
from tmp_yz_xy_XQGZ2024120201520_01 a
left join 
(select 
cell_code,
count(distinct case when cell_code<>cell_code_last then serv_id else null end ) as kd_yj202411
from tmp_yz_xy_XQGZ2024120201520_02
group by cell_code
) b
on a.cell_code=b.cell_code
---13249




