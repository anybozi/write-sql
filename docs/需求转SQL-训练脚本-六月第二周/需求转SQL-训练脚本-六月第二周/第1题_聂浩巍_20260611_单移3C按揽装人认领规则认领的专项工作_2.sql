需求原始内容：
非需求单的长期需求

广州本地划小规则：单移和3c号码以揽装人认领规则优先，若当前划小机构与揽装人认领规则责任田所属划小机构不一致，则需要取出并按揽装人认领规则的责任田对号码做服务认领。因此需要取出待处理的单移和3C号码及其待落入的责任田清单

需求梳理：
对本月和上月入网的移动和3C号码处理，按条件筛选后取出待处理的
要求：
1.取出两个月内入网的移动和3C号码并打标所有有用的信息
2.再取出满足以下所有条件的号码
①、有揽装人认领规则的
②、剔除划分规则为 套餐规则
③、剔除划小局向为省政企的，即COALESCe(subst_id,0)<>1160564
④、判断划小责任田与揽装规则责任田不一致且(1)号码划小包区与揽装人认领规则的责任田所属包区不一致 或 (2)号码划小包区与揽装人认领规则的责任田所属包区一致，但营服不一致（这些情况是用于筛选号码不落片区的情况）
⑤、剔除副卡
⑥、剔除需求单号码

输出字段：
服务标识，接入号，揽装人认领规则对应的责任田编码，揽装人认领规则对应责任田的责任田类型，号码的揽装人编码，揽装人认领规则对应的责任田ID，号码当前责任田ID，揽装人认领规则对应责任田的所属包区ID，号码当前包区ID，
揽装人认领规则对应责任田的所属营服ID，号码当前营服ID，揽装人认领规则对应责任田的所属分局ID，号码当前分局ID，号码入网时间，号码当前划分规则，号码当前认领规则，是否副卡

--提取本月和上月入网的移动和3C号码清单信息
drop table if exists ads_yz_dy3c_list;
create table ads_yz_dy3c_list as 
select par_month_id,serv_id,acc_nbr,open_date,sales_id,sales_code,
std_subst_id,std_branch_id,cell_code,cell_name,
subst_id,branch_id,area_id,grid_id,grid_name,prod_id,is_rh_ykj,rh_tc_id,is_vice_card,zk_acc_nbr,
(case when prod_id in (3204,3205) then 1 else 0 end) flag
from dwm_yz_tb_comm_cm_all_final 
where par_month_id = ${yyyymm} --改时间，当月
and (prod_id in (3204,3205) or prod_id in (select Prod_id from dwd_yz_3C_product))
and state<>'140001' and date_format(open_date,'yyyyMM')>='${last_month_id}'
and is_cancel_user=0
and (nvl(subst_id,-1) <> 940201816 or grid_code = '200041182068877')
and branch_id not in (select org_id from dwd_yz_dim_org_qd)
;

--匹配揽装人认领规则、号码当前划分认领规则和需求单清单
drop table if exists ads_yz_dy3c_list_sales_rule;
create table ads_yz_dy3c_list_sales_rule as 
select a.*,
b.grid_id grid_id_lz,
b.grid_name grid_name_lz,
b.grid_code grid_nbr_lz,
b.subst_name subst_name_lz,
b.subst_id subst_id_lz,
b.branch_name branch_name_lz,
b.branch_id branch_id_lz,
cast(b.area_id as string) region_id_lz,
b.grid_type_name,
case when b.grid_id is not null then 1 else 0 end flag2
,c.subst_rule,c.subst_date,c.grid_rule,c.grid_date,d.xqgz,
case when d.serv_id is not null then 1 else 0 end is_xq
from ads_yz_dy3c_list a
left join ads_yz_sales_grid_rule_list_cl b
on a.sales_code=b.sales_code
left join dwd_yz_jyfx_serv_grid_final c
on a.serv_id=c.serv_id
left join ads_yz_nhw_xqgz_all_2026 d
on a.serv_id=d.serv_id
;

--满足以下所有条件的才处理
--1、有揽装人认领规则的
--2、剔除划分规则为 套餐规则
--3、剔除划小局向为省政企的，即COALESCe(subst_id,0)<>1160564
--4、判断划小责任田与揽装规则责任田不一致
--   且(1)号码划小包区与揽装人认领规则的责任田所属包区不一致 或 (2)号码划小包区与揽装人认领规则的责任田所属包区一致，但营服不一致（这些情况是用于筛选号码不落片区的情况）
--5、剔除副卡
--6、剔除需求单号码

drop table if exists ads_yz_dy3c_sales_cl_list;
create table ads_yz_dy3c_sales_cl_list as 
select acc_nbr,grid_nbr_lz,grid_type_name,grid_name_lz,grid_name,grid_rule,is_vice_card,subst_rule,serv_id,open_date,
subst_id_lz,branch_id_lz,region_id_lz,subst_id,branch_id,grid_id_lz,grid_id,area_id,sales_code
from ads_yz_dy3c_list_sales_rule
where  flag2=1 
and COALESCe(subst_id,0)<>1160564
and  nvl(subst_rule,'-1') not in ('套餐规则') 	
and COALESCE(grid_Id,0)<>COALESCE(grid_id_lz,0)
and (
((area_id not in (0,-1) or region_id_lz not in (0,-1)) and COALESCE(area_id,0) <> COALESCE(region_id_lz,0))
or (area_id in (0,-1) and region_id_lz in (0,-1) and COALESCE(branch_id,0) <> COALESCE(branch_id_lz,0))
)
and is_vice_card = 0
and is_xq = 0
;

--提取最终处理号码字段
drop table if exists ads_yz_dy3c_sales_cl_list_final;
create table if not exists ads_yz_dy3c_sales_cl_list_final as 
select serv_id,acc_nbr,grid_nbr_lz,grid_type_name,sales_code,grid_id_lz,grid_id,region_id_lz,
area_id,branch_id_lz,branch_id,subst_id_lz,subst_id,open_date,subst_rule,grid_rule,is_vice_card
from ads_yz_dy3c_sales_cl_list
;