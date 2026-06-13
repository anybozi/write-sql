需求原始内容：
XQGZ2025011401468

黄埔申请1月促销网格（中海康城）九级地址。因本月促销大场需要，现申请提取1月促销网格（中海康城）九级地址，接入号详见附件，谢谢！

需求梳理：
需求方提供了网格单元中海康城内所有宽带接入号，要求获取接入号对应的9级地址。

要求：
1.需求附件中号码可能有拆机号码，这部分要剔除；
2.号码的装机标准地址正常为10级地址，但也可能不存在或并非10级地址，所以要匹配地址等级检查，本需求中无误。

输出字段：
接入号，9级地址ID，9级地址名称,地址等级

--需求附件导入CDAP，取号码对应的装机标准地址serv_addr_id
drop table tmp_XQGZ2025011401468;
create table tmp_XQGZ2025011401468 as
select serv_id, acc_nbr, open_date, std_subst_name, std_branch_name, cell_name,cell_code, subst_name, branch_name, area_name, grid_name,grid_code, serv_addr_id from 
dwm_yz_tb_comm_cm_all_final
where acc_nbr in (select index1 from zone_gz_yz_3466798313435136)
and par_month_id = 202501
;

--通过号码的装机标准地址serv_addr_id，匹配号码的9级地址id
drop table tmp_XQGZ2025011401468_serv_addr;
create table tmp_XQGZ2025011401468_serv_addr as
select a.*,b.addr,b.grade,b.parentid id_9
from tmp_XQGZ2025011401468 a
left join dwd_yz_addr_final b
on cast(serv_addr_id as decimal(24,0)) = b.id
;

--通过9级地址id，匹配9级地址名称，并获取地址等级检查是否确实为9级地址
drop table ads_yz_XQGZ2025011401468;
create table ads_yz_XQGZ2025011401468 as
select a.acc_nbr,a.id_9,b.addr addr9_name,b.grade grade9
from tmp_XQGZ2025011401468_serv_addr a
left join dwd_yz_addr_final b
on a.id_9 = b.id
;
