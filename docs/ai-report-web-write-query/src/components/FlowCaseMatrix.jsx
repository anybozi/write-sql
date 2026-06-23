import React from "react";
import {
  CheckCircle2,
  Database,
  FileCheck2,
  GitBranch,
  ShieldCheck,
} from "lucide-react";
import caseScreenshot from "../assets/case-age65-real-record.png";

const iconMap = {
  flow: GitBranch,
  rule: ShieldCheck,
  table: Database,
};

const caseStages = [
  {
    id: 1,
    title: "案例内容",
    desc: "口语需求：近三个月、65 岁以上机主、所有订单。",
    calloutIds: [1],
    assets: ["SKILL.md"],
    output: "识别业务对象、时间窗口、年龄限制和结果范围。",
  },
  {
    id: 2,
    title: "澄清判断",
    desc: "问清时间、订单范围、年龄口径、撤单/作废处理。",
    calloutIds: [2, 3],
    assets: ["SKILL.md", "ROUTING.md"],
    output: "把一句口语需求变成可确认的取数方案。",
  },
  {
    id: 3,
    title: "资产命中",
    desc: "040 取订单；069 补年龄；路由规则确定关联链路。",
    calloutIds: [4, 5],
    assets: ["ROUTING.md", "040_订单表", "069_资料表"],
    output: "明确表来源、关联路径和字段口径。",
  },
  {
    id: 4,
    title: "SQL 交付",
    desc: "多步 CTAS 生成，并附数量、去重、月份分布自检。",
    calloutIds: [6],
    assets: ["RULES.md"],
    output: "交付可执行、可校验、风险可控的 SQL。",
  },
];

const markerPlacement = {
  1: { x: 95.5, y: 6.5 },
  2: { x: 95.5, y: 19.5 },
  3: { x: 95.5, y: 37.5 },
  4: { x: 95.5, y: 43.5 },
  5: { x: 95.5, y: 52.5 },
  6: { x: 95.5, y: 80 },
};

/**
 * 左侧真实案例截图 + 右侧案例解读。
 *
 * @param {{
 *  rows: {
 *    callouts: Array<{ id: number, label: string, target: { x: number, y: number }, assetId: string }>,
 *    processAssets: Array<{ id: string, name: string, position: string, use: string, solves: string, anchorY: number, kind: "flow" | "rule" }>,
 *    tableAssets: Array<{ id: string, name: string, role: string, keyFields: string, anchorY: number }>
 *  }
 * }} props
 */
export function FlowCaseMatrix({ rows }) {
  const hitAssets = [...rows.processAssets, ...rows.tableAssets];
  const primaryAssets = hitAssets.filter((asset) =>
    ["skill", "routing", "backfill", "rules", "table040", "table069"].includes(
      asset.id,
    ),
  );

  return (
    <div className="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
      <div className="bg-slate-950 px-6 py-7 text-white md:px-8">
        <div className="flex flex-col gap-5 lg:flex-row lg:items-center lg:justify-between">
          <div className="max-w-4xl">
            <div className="mb-4 inline-flex items-center gap-2 rounded-full border border-brand-400/25 bg-white/5 px-3 py-1.5 text-xs font-bold uppercase tracking-wider text-brand-300">
              <FileCheck2 size={15} strokeWidth={1.8} />
              Real Case Evidence
            </div>
            <h3 className="mb-3 text-2xl font-black tracking-tight md:text-[32px]">
              真实案例证据板：左边看现场，右边看资产如何生效
            </h3>
            <p className="max-w-3xl leading-relaxed text-slate-300">
              截图负责证明这是一次真实取数过程；右侧只解释案例内容、命中的技能资产，以及最后交付了什么。
            </p>
          </div>
          <div className="rounded-2xl border border-white/10 bg-white/5 px-5 py-4 lg:w-[360px]">
            <div className="text-xs font-black uppercase tracking-wider text-brand-300">
              业务原话
            </div>
            <p className="mt-2 text-sm font-semibold leading-relaxed text-slate-100">
              近三个月，机主年龄大于等于 65 岁的所有订单。
            </p>
          </div>
        </div>
      </div>

      <div className="bg-slate-50 p-5 md:p-7">
        <div className="grid gap-5 md:grid-cols-[minmax(0,0.98fr)_minmax(340px,0.92fr)] md:items-start xl:grid-cols-[minmax(0,1.04fr)_minmax(380px,0.96fr)]">
          <div className="rounded-[1.25rem] border border-slate-200 bg-white p-4 shadow-sm">
            <div className="mb-3 flex items-center justify-between gap-4">
              <div>
                <div className="text-xs font-black uppercase tracking-wider text-brand-600">
                  真实案例截图
                </div>
                <h4 className="mt-1 text-lg font-black text-slate-950">
                  一次真实自然语言取数过程
                </h4>
              </div>
              <div className="hidden rounded-full border border-slate-200 bg-slate-50 px-3 py-1 text-xs font-black text-slate-500 md:block">
                只标节点，不画长箭头
              </div>
            </div>

            <div className="relative overflow-hidden rounded-2xl border border-slate-300 bg-slate-950 shadow-inner">
              <img
                src={caseScreenshot}
                alt="write-query 处理 65 岁机主订单需求的真实案例截图"
                className="block w-full"
              />
              {rows.callouts.map((callout) => {
                const marker = markerPlacement[callout.id] || callout.target;

                return (
                  <div
                    key={callout.id}
                    className="absolute z-10 flex -translate-x-1/2 -translate-y-1/2 items-center"
                    style={{
                      left: `${marker.x}%`,
                      top: `${marker.y}%`,
                    }}
                  >
                    <span className="flex h-6 w-6 items-center justify-center rounded-full border-2 border-white bg-brand-600 text-[10px] font-black text-white shadow-md shadow-slate-950/30 ring-2 ring-brand-100/70">
                      {callout.id}
                    </span>
                  </div>
                );
              })}
            </div>

            <div className="mt-3 grid gap-2 sm:grid-cols-3">
              {rows.callouts.map((callout) => (
                <div
                  key={`node-${callout.id}`}
                  className="flex min-w-0 items-center gap-2 rounded-xl border border-slate-200 bg-slate-50 px-3 py-2"
                >
                  <span className="flex h-5 w-5 flex-shrink-0 items-center justify-center rounded-full bg-brand-600 text-[10px] font-black text-white">
                    {callout.id}
                  </span>
                  <span className="truncate text-xs font-black text-slate-700">
                    {callout.label}
                  </span>
                </div>
              ))}
            </div>
          </div>

          <div className="space-y-4">
            <div className="rounded-[1.25rem] border border-slate-200 bg-white p-4 shadow-sm">
              <div className="mb-3 flex items-end justify-between gap-3">
                <div>
                  <div className="text-xs font-black uppercase tracking-wider text-brand-600">
                    Case Reading
                  </div>
                  <h4 className="mt-1 text-lg font-black text-slate-950">
                    这个案例说明了什么
                  </h4>
                </div>
                <span className="rounded-full border border-slate-200 bg-slate-50 px-3 py-1 text-xs font-black text-slate-500">
                  对应左图 1-6
                </span>
              </div>
              <div className="grid gap-2">
                {caseStages.map((stage) => (
                  <div
                    key={stage.id}
                    className="grid gap-3 rounded-2xl border border-slate-200 bg-slate-50 p-3 md:grid-cols-[minmax(0,0.78fr)_minmax(0,1fr)] md:items-start"
                  >
                    <div className="flex min-w-0 items-start gap-3">
                      <span className="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-xl bg-brand-600 text-xs font-black text-white">
                        {stage.id}
                      </span>
                      <div className="min-w-0">
                        <h5 className="text-base font-black text-slate-950">
                          {stage.title}
                        </h5>
                        <div className="mt-1 flex flex-wrap gap-1">
                          {stage.calloutIds.map((id) => {
                            const callout = rows.callouts.find(
                              (item) => item.id === id,
                            );

                            return (
                              <span
                                key={id}
                                className="rounded-full bg-white px-2 py-0.5 text-[10px] font-black text-slate-500"
                              >
                                {id} · {callout?.label}
                              </span>
                            );
                          })}
                        </div>
                      </div>
                    </div>
                    <div className="min-w-0">
                      <p className="text-[13px] leading-relaxed text-slate-600">
                        {stage.desc}
                      </p>
                      <div className="mt-2 flex flex-wrap gap-1.5">
                        {stage.assets.map((asset) => (
                          <code
                            key={asset}
                            className="rounded-full border border-brand-100 bg-white px-2 py-0.5 text-[11px] font-black text-brand-700"
                          >
                            {asset}
                          </code>
                        ))}
                      </div>
                    </div>
                  </div>
                ))}
              </div>
            </div>

            <div className="rounded-[1.25rem] border border-slate-200 bg-white p-4 shadow-sm">
              <div className="mb-3 flex items-center justify-between gap-3">
                <div>
                  <div className="text-xs font-black uppercase tracking-wider text-brand-600">
                    Asset Hits
                  </div>
                  <h4 className="mt-1 text-lg font-black text-slate-950">
                    本案例命中的技能资产
                  </h4>
                </div>
                <span className="rounded-full bg-slate-100 px-3 py-1 text-xs font-black text-slate-500">
                  {primaryAssets.length} 个
                </span>
              </div>
              <div className="grid gap-2 sm:grid-cols-2">
                {primaryAssets.map((asset) => {
                  const AssetIcon = iconMap[asset.kind] || Database;

                  return (
                    <div
                      key={asset.id}
                      className="rounded-2xl border border-slate-200 bg-slate-50 p-3"
                    >
                      <div className="mb-2 flex min-w-0 items-center gap-2">
                        <span className="flex h-8 w-8 flex-shrink-0 items-center justify-center rounded-xl bg-white text-brand-600 shadow-sm">
                          <AssetIcon size={16} strokeWidth={1.8} />
                        </span>
                        <div className="min-w-0">
                          <code className="block truncate text-xs font-black text-brand-700">
                            {asset.name}
                          </code>
                          <div className="mt-0.5 text-xs font-black text-slate-950">
                            {asset.position || asset.role}
                          </div>
                        </div>
                      </div>
                      <p className="line-clamp-2 text-xs leading-relaxed text-slate-600">
                        {asset.solves || asset.keyFields}
                      </p>
                    </div>
                  );
                })}
              </div>

              <div className="mt-3 rounded-2xl border border-brand-100 bg-brand-50 px-4 py-3 text-sm font-semibold leading-relaxed text-slate-800">
                这个案例的价值不在于“AI 写了一段 SQL”，而在于把人员取数经验拆成可调用资产，再约束 SQL 生成和自检交付。
              </div>
            </div>
          </div>
        </div>
      </div>
    </div>
  );
}
