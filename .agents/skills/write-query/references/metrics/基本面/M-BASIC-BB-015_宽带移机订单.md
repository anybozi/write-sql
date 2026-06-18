---
metric_id: "M-BASIC-BB-015"
metric_name: "宽带移机订单"
domain: "基本面"
category: "宽带"
period: "月/年"
cdap_flow: "移机订单表"
owners:
  business: ""
  technical: ""
source_file: "移机订单案例沉淀"
---

# [M-BASIC-BB-015] 宽带移机订单

## 指标属性

| 字段 | 值 |
|------|-----|
| 业务板块 | 基本面 |
| 业务分类 | 宽带 |
| 统计周期 | 月/年 |
| CDAP生产流程 | 移机订单表 |

## 业务口径

本口径定义有效竣工移机订单的统一取数底表，既可用于统计移机订单量，也可用于输出移机订单明细。

数据来源按年份分段：

- `2022` 年至今：直接使用 118 移机订单表 `dwd_yz_rpt_comm_ba_subs_move_final`。
- `2021` 年：118 尚无数据，使用 040 号码订单月表 `zone_gz_yz.dwm_yz_rpt_comm_ba_subs_mon_final` 重建。

## 2022 年至今口径

118 已经是移机订单专项结果表，直接使用 `month_id` 限制移机业务月份：

- `month_id BETWEEN ${start_month} AND ${end_month}`
- `par_month_id` 仅用于物理分区裁剪，不替代 `month_id` 业务月份；若未确认两者完全一致，不要强制使用相同范围。
- 查量：`count(distinct subs_id)`。
- 查明细：保留满足月份条件的订单行，按需求选择前后地址、机构、网格及揽装字段。

```sql
SELECT count(distinct subs_id) AS move_order_cnt
FROM dwd_yz_rpt_comm_ba_subs_move_final
WHERE month_id BETWEEN '${start_month}' AND '${end_month}'
;
```

如需分区裁剪，应使用单独确认的 `${partition_start_month}`、`${partition_end_month}`，并保证完整覆盖目标 `month_id` 数据。

## 2021 年历史重建口径

040 月表中必须同时满足以下固定条件：

```sql
action_type = 'MOVE'
AND subs_stat = '301200'
AND COALESCE(subs_stat_reason,'-1') NOT IN ('1200','1300')
```

时间及去重规则：

- 使用 `subs_stat_date` 限制移机业务时间，并生成移机月份。
- 040 `par_month_id` 是归档月，只用于归档批次裁剪，不能作为移机月份。
- 同一 `subs_id` 按 `subs_stat_date DESC` 排序，只保留最新一条。
- 069 移机当月月表快照作为移机后资料；上一个自然月快照作为移机前资料。

```sql
SELECT *
FROM (
    SELECT
        date_format(a.subs_stat_date, 'yyyyMM') AS month_id,
        a.*,
        row_number() over(
            partition by a.subs_id
            order by a.subs_stat_date desc
        ) AS rn
    FROM zone_gz_yz.dwm_yz_rpt_comm_ba_subs_mon_final a
    WHERE a.par_month_id >= 202101
      AND a.action_type = 'MOVE'
      AND a.subs_stat = '301200'
      AND COALESCE(a.subs_stat_reason,'-1') NOT IN ('1200','1300')
      AND substr(cast(a.subs_stat_date as string),1,10) >= '2021-01-01'
      AND substr(cast(a.subs_stat_date as string),1,10) <  '2022-01-01'
) t
WHERE rn = 1
;
```

## 量与明细的使用方式

- 用户问“移机量、移机订单数”：在上述口径底表上使用 `count(distinct subs_id)`。
- 用户问“移机明细、移机信息”：不聚合，保留相同过滤口径，并按需求输出订单、地址、机构、网格和揽装字段。
- 查询跨越 2021 和 2022 年时，分别生成 2021 重建分支与 118 分支，统一字段类型和列顺序后 `UNION ALL`。

## 依赖说明

- 118 表结构与覆盖期：`../../tables/118_移机订单表.md`。
- 040 订单当前表/月表规则：`../../tables/040_全业务号码订单表.md`。
- 069 当月/上月快照：`../../tables/069_全业务资料表.md`。
- 地址中文名称按需补 079 地址维表；历史揽装归属按需补 113 月表。
