需求原始内容：
XQGZ2026060302231

因单移运营考核需要，在降档清单新增以下字段：不看降档揽装，均按实际降档受理
1、降档订单受理单位，取降档订单的受理人所在单位，如万号、天河分公司等
2、降档订单受理网点，取降档订单受理人所在网点
3、降档订单受理渠道，取降档订单受理人所在渠道，按降档清单原有的渠道分类、、
4、降档订单受理人理人
5、降档订单受理人工号


需求梳理：
经与需求方沟通，因为没有受理人所在渠道这种东西，故第三点无需处理。
按第一点处理受理单位，包括受理分局，受理营服，受理机构
第二点处理受理网点
第四点，第五点处理受理人信息



输出字段：
受理单位、受理网点、受理人、受理人ID。


-- 拉取降档清单当月临时表，按降档订单和接入号关联受理信息,优惠资料表可能有多条重复记录，按订单和接入号分区后排序取第一条记录
-- tmp_yz_jd_20260422_1 为降档清单跑数临时表
drop table if exists tmp_yz_jd_XQGZ2026060302231_list1;
  create table tmp_yz_jd_XQGZ2026060302231_list1 as 
  select a.*,b.staff_id, b.staff_org_id,b.staff_subst_id,b.staff_branch_id,b.salestaff_region_id
  from tmp_yz_jd_20260422_1 a
  left join 
  (select *,ROW_NUMBER() OVER (PARTITION BY subs_code, serv_id ORDER BY serv_id DESC) as rn from dwm_yz_rpt_comm_ba_msdisc_final ) b
  on a.jd_subs_code = b.subs_code and a.serv_id = b.serv_id and b.rn=1
  where a.par_month_id= '$month_id';

 
 
 --匹配机构表和员工表关联打标机构信息
drop table if exists tmp_yz_jd_XQGZ2026060302231_list2;
create table tmp_yz_jd_XQGZ2026060302231_list2 as
select a.*
			,b.subst_name staff_subst_name,
            b.branch_name staff_branch_name,
            b.org_name staff_org_name,
            b.region_type staff_region_type,
            c.sales_man_name as staff_name,
	        c.channel_nbr as staff_channel_nbr,
	        c.channel_name as staff_channel_name
from tmp_yz_jd_XQGZ2026060302231_list1 a
left join dwd_yz_dim_org b on a.staff_org_id=b.org_id
left join (select * from zone_gz_yz.dwd_yz_sales_man_outlers_mon_final where par_month_id='$month_id' and
  staff_status_cd = '1000' ) c on a.staff_id=c.staff_id
;
 

