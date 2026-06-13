需求原始内容：
因提升要客服务工作需要，申请通过接入号匹配产权客户编码，清单请见附件，谢谢！


输出字段：
接入号,产权客户编码


--导入号码信息并匹配产权客户编码cust_nbr
drop table zone_gz_yz.tmp_yz_XQGZ2026060300078;
create table zone_gz_yz.tmp_yz_XQGZ2026060300078
row format delimited fields terminated by '\u0001' stored as orc tblproperties('orc.compression'='snappy')     
as
select cast(index1 as int) as row_num,index2 as acc_nbr,
case when b.serv_id is null then '找不到此号码' else b.cust_nbr end as cust_nbr
from zone_gz_yz.zone_gz_yz_343 a
left join
(select serv_id,acc_nbr,cust_id,cust_nbr
from dwm_yz_tb_comm_cm_all_final
where par_month_id=202606
and prod_type=30) b
on a.index2=b.acc_nbr;


--输出结果
select row_num,acc_nbr,cust_nbr
from tmp_yz_XQGZ2026060300078 
order by row_num limit 1000