需求原始内容：
XQGZ2026050800361
1）IPCYW2556442062续约没有乘年限系数1.3，
应发积分21500*0.6*1.3=16770，只发了21500*0.6=12900，请补发16770-12900=3870。
2）ADSLS2613771253新装没有乘年限系数1.3。
3月T+1应发积分10000*2*1.3/2=13000，只发了10000*2/2=10000，请补发13000-10000=3000.
没有乘年限系数的原因是因为首月做了特殊合同执行，导致正式执行时年限不足2年，但实际是2年合约，
见附件合同和crm截图。根据第一季度积分规则，请补发积分。


需求梳理：
经沟通，
1. IPCYW2556442062 申诉续约年限，核查该专线续约合同期是否正确
2. ADSLS2613771253 申诉新装年限，核查该专线新装合同期是否正确

专线续约规则：
一、续约激励
1、激励规则：
≥原套餐价值：0.6倍新套餐价值*年限系数
≥原套餐价值60%：0.3倍新套餐价值*年限系数 
＜原套餐价值60%：0
2、年限系数：1年≤协议期＜2年，1倍；2年≤协议期＜3年，1.3倍；协议期≥3年，1.6倍。其中协议期：最新协议到期时间-上一期协议到期时间
二、续约条件
（一）当期自动续约不纳入统计
（二）未集约产品按照本地CRM协议起止时间；集约产品按照集团CRM合同起止时间
三、发放规则：T+1号码状态满足在网不欠费，则一次性发放。对于停机欠费用户三个月内缴费复通可进行补结。

专线新装规则：
一、激励规则：月租*激励系数*年限系数
1、激励系数：400元及以上2倍、400元以下1倍
2、年限系数：1年≤协议期＜2年，1倍；2年≤协议期＜3年，1.3倍；协议期≥3年，1.6倍
3、针对双线一次性费用，按1/12下发激励
二、发放规则：号码状态满足在网不欠费，T+1、T+3各放50%。对于停机欠费用户三个月内缴费复通可进行补结。







-- 核查续约专线，取出当前续约销售品的协议有效期和续约前的销售品协议有效期。
select
  c.acc_nbr,
  c.serv_id,
  c.agree_month,
  c.limit_date   as new_limit_date,
  o.limit_date   as old_limit_date,
  o.open_date    as old_open_date,

  ceil(months_between(c.limit_date, o.limit_date)) as agree_month1, -- 新销售品的到期时间-旧销售品到期时间
  ceil(months_between(o.limit_date, o.open_date)) as agree_month_old, -- 旧销售品的协议期

  case
    when o.limit_date is null then c.agree_month
    when ceil(months_between(c.limit_date, o.limit_date)) < 0
     and ceil(months_between(o.limit_date, o.open_date)) > 10
    then c.agree_month
    else ceil(months_between(c.limit_date, o.limit_date))
  end as agree_month_last -- 最终协议期

from (
  select
   acc_nbr,
    serv_id,
    open_date,
    limit_date,
    ceiling(
      months_between(
        date_format(limit_date,'yyyy-MM-dd'),
        date_format(open_date,'yyyy-MM-dd')
      )
    ) as agree_month
  from dwd_yz_rpt_comm_cm_msdisc_mon_final   -- 优惠订单表
  where par_month_id = 202603
    and acc_nbr in ('IPCYW2556442062','ADSLS2613771253')
    and prod_offer_id in (
      select prod_offer_id
      from summary_jf_szx.tb_score_disc_config_all  
      where disc_type = '专线月租优惠'
        and disc_dl = '专线协议'
    )
) c
left join (
  select
    open_date,
    limit_date
  from dwd_yz_rpt_comm_cm_msdisc_mon_final
  where par_month_id < 202603
    and acc_nbr in ('IPCYW2556442062','ADSLS2613771253')
    and prod_offer_id in (
      select prod_offer_id
      from summary_jf_szx.tb_score_disc_config_all   -- 销售品配置表
      where disc_type = '专线月租优惠'
        and disc_dl = '专线协议'
    )
  order by limit_date desc
  limit 1
) o on 1=1;