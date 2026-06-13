需求原始内容：XQGZ2026060500600
为开展公司名信安梳理要求，申请提取公司名移动10户以上的客户清单，提取口径：公司名，移动业务，自然年内入网量超10户产权客户
提取具体字段见附件，建立广州视图以及11个区分和4个客户中心视图（按照划小或揽装人所属机构属于这个单位）


输出字段：
划小分局,划小营服,产权客户编码,产权客户名称,揽装人,揽装人编码,揽装人所属分局,揽装人所属营服,入网量,入网积分,停拆机量,停拆机占比,最早入网时间,移动到达数



--统计公司名客户名下当年的移动入网数
drop table tmp_yz_gsm_yd_rw_over10_cust;
create table tmp_yz_gsm_yd_rw_over10_cust
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')     
as
select cust_id,count(serv_id) as yd_rw
from zone_gz_yz.dwm_yz_tb_comm_cm_all_mon_final
where par_month_id>='202601'
and par_month_id<='202605'
and is_gsm=1
and prod_type=30
and is_new_user=1
group by cust_id;


--提取公司名客户年入网>=10的移动入网号码清单
drop table tmp_yz_gsm_yd_rw_over10_cust1;
create table tmp_yz_gsm_yd_rw_over10_cust1
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')     
as
select serv_id,acc_nbr,open_date,is_new_user,subst_id,subst_name,branch_id,branch_name,
cust_id,cust_nbr,cust_name,sales_id,sales_name,sales_code,jz_points
from zone_gz_yz.dwm_yz_tb_comm_cm_all_mon_final
where par_month_id>='202601'
and par_month_id<='202605'
and is_gsm=1
and prod_type=30
and is_new_user=1
and cust_id in (select cust_id from tmp_yz_gsm_yd_rw_over10_cust where yd_rw>=10);


--更新揽装人局向和营服信息
drop table tmp_yz_gsm_yd_rw_over10_cust2;
create table tmp_yz_gsm_yd_rw_over10_cust2
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')     
as
select a.*,c.subst_name as sales_subst_name,c.branch_name as sales_branch_name
from tmp_yz_gsm_yd_rw_over10_cust1 a
left join 
(select sales_code,own_channel_id,
row_number() over(partition by sales_code order by create_date desc) as order_id
from zone_gz_yz.dwd_yz_sales_man_mon_final
where par_month_id=202605
) as b
on a.sales_code=b.sales_code and b.order_id=1
left join
(select channel_id,own_org_name,subst_name,branch_name,
row_number() over(partition by channel_id order by create_date desc) as order_id
from zone_gz_yz.dwd_yz_sale_outlers_mon_final
where par_month_id=202605
) as c
on b.own_channel_id=c.channel_id and c.order_id=1;


--更新号码状态信息
drop table tmp_yz_gsm_yd_rw_over10_cust3;
create table tmp_yz_gsm_yd_rw_over10_cust3
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')     
as
select a.*,
case when b.serv_id is null then '拆机' else c.attr_value_name end as state
from tmp_yz_gsm_yd_rw_over10_cust2 a
left join 
(select serv_id,state
from dwm_yz_tb_comm_cm_all_mon_final
where par_month_id=202605
and prod_type=30
and is_cancel_user=0
) as b
on a.serv_id=b.serv_id
left join
(select attr_value,attr_value_name
from dws_crm_cfguse.dws_attr_value
where city_id='200' 
and attr_id='4000000201'
) as c 
on b.state=c.attr_value;


--生成多维表并匹配客户移动在网用户数及最早入网时间
drop table tmp_yz_gsm_yd_rw_over10_cust4;
create table tmp_yz_gsm_yd_rw_over10_cust4
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')     
as
select a.*,a.yd_tcj/a.yd_rw as yd_tcj_rate,b.yd_zw_cnt,b.first_open_date
from
(
select subst_name,branch_name,cust_id,cust_nbr,cust_name,sales_name,sales_code,sales_subst_name,sales_branch_name,
count(serv_id) as yd_rw,
sum(jz_points) as yd_jz_points,
count(case when state in ('拆机','停机') then serv_id end) as yd_tcj
from tmp_yz_gsm_yd_rw_over10_cust3
group by subst_name,branch_name,cust_id,cust_nbr,cust_name,sales_name,sales_code,sales_subst_name,sales_branch_name
) as a 
left join
(select cust_id,count(serv_id) yd_zw_cnt,min(open_date) as first_open_date
from dwm_yz_tb_comm_cm_all_mon_final
where par_month_id=202605
and prod_type=30
and is_cancel_user=0
and is_phs_tk='0'
and state<>'140001'
group by cust_id
) as b
on a.cust_id=b.cust_id;
			

--输出结果
select subst_name,branch_name,cust_nbr,cust_name,sales_name,sales_code,sales_subst_name,sales_branch_name,
yd_rw,yd_jz_points,yd_tcj,yd_tcj_rate,yd_zw_cnt,first_open_date
from tmp_yz_gsm_yd_rw_over10_cust4;