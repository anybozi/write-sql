/**
 * @file 老年客群订单案例演示数据 + 页面全局数据
 */

export const caseAge65Demo = {
  userQuery:
    "请教下，能帮忙取一下近三个月，机主年龄大于等于65岁的所有订单不？",

  // ── 背景/痛点 ──
  painPoints: [
    {
      title: "取数靠经验，无法复用",
      desc: "业务人员高度依赖少数支撑人员，需求靠口头传递。人员一旦变动，经验就流失，同样的需求要反复沟通、重新摸索。",
    },
    {
      title: "口径不统一，结果不一致",
      desc: "同一个指标，不同人取数结果不同——时间窗口、过滤条件、关联路径没有统一标准，数据质量难以保证。",
    },
    {
      title: "响应周期长，效率低",
      desc: "从需求提出到 SQL 交付，平均需要反复沟通数小时。遇到复杂需求，跨表关联、字段补全更是耗时。",
    },
  ],

  // ── 能力沉淀统计 ──
  assetStats: {
    tables: 121,
    metrics: 91,
    cases: 16,
  },

  // ── 核心资产类型 ──
  assetTypes: [
    {
      name: "SKILL.md",
      title: "运行流程入口",
      kind: "entry",
      desc: "定义自然语言取数的标准节奏：先澄清需求，再方案确认，最后生成 SQL 并自检。",
    },
    {
      name: "METRIC_INDEX.md",
      title: "标准指标口径",
      kind: "metric",
      desc: "91 个标准指标，每个指标含 ID、名称、技术口径和来源表，一次定义、多次复用。",
    },
    {
      name: "TABLE_INDEX.md",
      title: "表资产索引",
      kind: "table",
      desc: "121 张表文档，按业务主题分类，含字段、分区、粒度和关联说明。",
    },
    {
      name: "ROUTING.md",
      title: "主表路由规则",
      kind: "route",
      desc: "把业务口语映射到取数路径，避免 AI 直接猜表名、猜字段。",
    },
    {
      name: "FIELD_BACKFILL.md",
      title: "字段补表规则",
      kind: "route",
      desc: "当主表缺字段时，说明该补哪张表、用什么关联键、有哪些粒度风险。",
    },
    {
      name: "RULES.md",
      title: "SQL 审计规则",
      kind: "rule",
      desc: "约束时间口径、隐私字段、多步 CTAS、自检 SQL 等交付要求，确保可执行、可验收。",
    },
    {
      name: "verified-cases/",
      title: "验证案例库",
      kind: "case",
      desc: "16 个已验证的真实案例，可复用路径和口径，加速相似需求响应。",
    },
  ],

  // ── 案例：需求澄清 ──
  clarification: [
    "时间范围：近三个月，受理时间 act_date 202604–202606",
    "年龄口径：机主年龄 ≥ 65 岁，按身份证号 social_id 推算当前年龄",
    "订单范围：全量订单（号码订单 040 + 优惠订单 041），不排除撤单/作废/未竣工",
    "默认假设：机主信息取自 069 资料表；非身份证证件无法算年龄会被排除",
  ],

  // ── 案例：方案确认 ──
  planRows: [
    { item: "查什么", value: "订单明细（号码订单 040 + 优惠订单 041）" },
    {
      item: "年龄",
      value:
        "069 最新资料月，按身份证 social_id 推算，≥65 岁（当前年份减出生年）",
    },
    {
      item: "时间",
      value: "受理时间 act_date，近三个月 202604–202606",
    },
    {
      item: "订单范围",
      value: "040 + 041 全部状态，不排除撤单/作废/未竣工",
    },
    {
      item: "默认假设",
      value:
        "机主信息取自 069 资料；非身份证证件无法算年龄会被排除",
    },
  ],

  // ── 案例：命中的资产 ──
  caseAssets: [
    {
      name: "SKILL.md",
      role: "运行流程",
      use: "指导 AI 先做需求澄清，再方案确认，最后生成 SQL。",
    },
    {
      name: "ROUTING.md",
      role: "表路由",
      use: "命中「年龄客群 + 订单明细」路由：069 圈 serv_id → 040/041 订单池。",
    },
    {
      name: "FIELD_BACKFILL.md",
      role: "补表规则",
      use: "订单表没有年龄字段，需要补 069 当前资料月后再关联订单。",
    },
    {
      name: "040_全业务号码订单表.md",
      role: "订单主表",
      use: "取所有订单明细；按 act_date 过滤近三个月。",
    },
    {
      name: "069_全业务资料表.md",
      role: "年龄补表",
      use: "取当前资料月，用 social_id / social_id_type 推算机主年龄。",
    },
  ],

  // ── 案例：流程走通 ──
  flowSteps: [
    {
      title: "拆需求",
      source: "用户输入",
      desc: "抽出业务对象、时间口径、输出粒度和限制条件。",
    },
    {
      title: "读技能入口",
      source: "SKILL.md",
      desc: "判断走标准指标、主表路由还是补表路径。",
    },
    {
      title: "定主表路由",
      source: "ROUTING.md",
      desc: "命中「年龄客群+订单明细」：069 → 040/041。",
    },
    {
      title: "锁字段与补表",
      source: "tables/ + FIELD_BACKFILL",
      desc: "069 算年龄；040/041 合并订单池。",
    },
    {
      title: "方案确认",
      source: "一次对齐",
      desc: "主表、年龄快照、时间字段、订单范围一次说清。",
    },
    {
      title: "审计交付",
      source: "RULES.md",
      desc: "多步 CTAS、分区裁剪、自检 SQL 与风险提示。",
    },
  ],

  // ── 案例：SQL 交付 ──
  sqlSteps: [
    {
      step: 1,
      table: "tmp_age65_serv_202606",
      title: "圈老年客群 serv_id",
      desc: "069 最新资料月，身份证推算 age ≥ 65",
    },
    {
      step: 2,
      table: "tmp_age65_order_pool_202606",
      title: "合并 040/041 订单池",
      desc: "归档月表 UNION 当前表，按 subs_id 去重",
    },
    {
      step: 3,
      table: "ads_age65_order_3m_202606",
      title: "关联输出最终结果",
      desc: "serv_id 关联 + act_date 近三个月过滤",
    },
  ],

  sqlSnippet: `-- Step1: 069 最新资料月圈 age >= 65
create table tmp_age65_serv_202606 as
select serv_id, acc_nbr, ...
from dwm_yz_tb_comm_cm_all_final a
where par_month_id = (select max(par_month_id) from dwm_yz_tb_comm_cm_all_final)
  and case when length(social_id)=18 and social_id_type='1'
       then year(current_date)-cast(substr(social_id,7,4) as int)
       ... end >= 65;

-- Step2: 040/041 月表 + 当前表合并去重
-- Step3: inner join + act_date 202604-202606`,

  selfCheck: [
    "select count(*), count(distinct serv_id) from tmp_age65_serv_202606",
    "select count(*), count(distinct subs_id) from ads_age65_order_3m_202606",
    "按 order_type、受理月 group by 检查分布是否合理",
  ],

  // ── 案例：截图标注点 ──
  annotations: [
    {
      id: 1,
      label: "业务同事用自然语言提需求",
      target: { x: 78, y: 8 },
      labelPos: { x: 52, y: 2 },
    },
    {
      id: 2,
      label: "技能按流程检索知识库",
      target: { x: 12, y: 42 },
      labelPos: { x: 2, y: 18 },
    },
    {
      id: 3,
      label: "锁定字段、分区与口径来源",
      target: { x: 42, y: 38 },
      labelPos: { x: 28, y: 22 },
    },
    {
      id: 4,
      label: "先对齐主表与时间口径",
      target: { x: 76, y: 32 },
      labelPos: { x: 55, y: 26 },
    },
    {
      id: 5,
      label: "输出可落盘、可验收的 Hive SQL",
      target: { x: 78, y: 72 },
      labelPos: { x: 50, y: 88 },
    },
  ],

  // ── 下一步规划 ──
  roadmap: [
    {
      phase: "短期",
      label: "覆盖更多业务场景",
      items: ["续约、积分、成本、降档等高频场景", "完善 FIELD_BACKFILL 补表规则覆盖率"],
    },
    {
      phase: "中期",
      label: "案例库与质量闭环",
      items: ["沉淀 30+ 验证案例，覆盖 80% 日常取数", "建立案例回测机制，资产变更自动回归"],
    },
    {
      phase: "长期",
      label: "从辅助取数到自助取数",
      items: ["业务人员通过自然语言直接取数", "AI 自动识别指标、路由、补表，零门槛使用"],
    },
  ],
};