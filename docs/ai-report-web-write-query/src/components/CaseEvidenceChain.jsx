import clarifyShot from "../../正式对话记录/对话记录截图/01.png";
import planShot from "../../正式对话记录/对话记录截图/02.png";
import sqlShot from "../../正式对话记录/对话记录截图/03.png";

const evidence = [
  {
    id: "evidence-clarify",
    step: "01",
    eyebrow: "需求澄清",
    title: "先把会改变 SQL 的问题问清楚",
    desc: "AI 没有直接写 SQL，而是先锁定受理时间、年龄快照和输出粒度三个关键口径。",
    image: clarifyShot,
    alt: "真实对话截图：AI 对近三个月老年机主订单需求提出三个澄清问题",
    focus: "object-[center_12%]",
  },
  {
    id: "evidence-plan",
    step: "02",
    eyebrow: "方案确认",
    title: "把主表、补表、时间和风险一次说透",
    desc: "方案明确使用 040 订单表、069 当前资料月，并提前说明订单去重与 JOIN 放大风险。",
    image: planShot,
    alt: "真实对话截图：AI 输出主表、时间、补表、过滤和风险方案",
    focus: "object-top",
  },
  {
    id: "evidence-sql",
    step: "03",
    eyebrow: "SQL 交付",
    title: "确认后再生成可落盘、可自检的脚本",
    desc: "最终按确认口径生成四段 CTAS，并附带覆盖数据量、重复、状态和字段质量的自检 SQL。",
    image: sqlShot,
    alt: "真实对话截图：AI 生成完整 Hive SQL 与自检方案",
    focus: "object-top",
  },
];

export function CaseEvidenceChain() {
  return (
    <div id="case-evidence-chain" className="case-evidence-chain">
      {evidence.map((item, index) => (
        <article
          key={item.id}
          id={item.id}
          data-case-evidence
          className="case-evidence-card reveal"
        >
          <div className="case-evidence-copy">
            <div className="case-evidence-step">{item.step}</div>
            <p className="case-evidence-eyebrow">{item.eyebrow}</p>
            <h4>{item.title}</h4>
            <p>{item.desc}</p>
            <span className="case-evidence-proof">真实对话记录</span>
          </div>
          <figure className="case-evidence-frame">
            <img
              src={item.image}
              alt={item.alt}
              className={item.focus}
              loading={index === 0 ? "eager" : "lazy"}
            />
          </figure>
        </article>
      ))}
    </div>
  );
}
