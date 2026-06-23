import React from "react";
import { Database, FileCheck2, FileText, GitBranch, ShieldCheck } from "lucide-react";
import caseScreenshot from "../assets/case-age65-real-record.png";

const iconMap = {
  flow: GitBranch,
  rule: ShieldCheck,
  table: Database,
};

/**
 * 真实案例截图 + 技能资产调用图谱。
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
  const calloutsByAsset = rows.callouts.reduce((acc, callout) => {
    acc[callout.assetId] = [...(acc[callout.assetId] || []), callout];
    return acc;
  }, {});

  return (
    <div className="overflow-hidden rounded-2xl border border-slate-200 bg-white shadow-sm">
      <div className="border-b border-slate-200 bg-slate-950 p-6 text-white md:p-8">
        <div className="mb-4 inline-flex items-center gap-2 text-xs font-bold uppercase tracking-wider text-brand-300">
          <FileCheck2 size={15} strokeWidth={1.8} />
          Case Asset Map
        </div>
        <h3 className="mb-3 text-2xl font-black tracking-tight md:text-3xl">
          左边是真实案例现场，右边是本次调用到的技能资产
        </h3>
        <p className="max-w-4xl leading-relaxed text-slate-300">
          左侧真实截图只保留关键动作编号，避免遮挡原始对话；右侧按编号说明本次调用到的技能资产，
          讲清楚文件用途、案例中怎么用、解决了什么口径问题。
        </p>
      </div>

      <div className="relative grid gap-0 bg-slate-50 lg:grid-cols-[minmax(0,1.15fr)_minmax(390px,0.85fr)]">
        <div className="relative p-5 md:p-8">
          <div className="relative overflow-hidden rounded-2xl border border-slate-300 bg-slate-900 shadow-xl">
            <img
              src={caseScreenshot}
              alt="write-query 处理 65 岁机主订单需求的真实案例截图"
              className="block h-auto w-full"
            />
            {rows.callouts.map((callout) => (
              <div
                key={callout.id}
                className="absolute right-3 z-20 flex -translate-y-1/2 items-center gap-2"
                style={{
                  top: `${callout.target.y}%`,
                }}
              >
                <span className="flex h-7 w-7 items-center justify-center rounded-full border-2 border-white bg-brand-600 text-xs font-black text-white shadow-lg shadow-brand-950/30 ring-4 ring-white/70">
                  {callout.id}
                </span>
              </div>
            ))}
          </div>

          <div className="mt-4 rounded-2xl border border-slate-200 bg-white p-3 shadow-sm">
            <div className="grid gap-2 sm:grid-cols-2 xl:grid-cols-3">
              {rows.callouts.map((callout) => (
                <div
                  key={`legend-${callout.id}`}
                  className="flex min-w-0 items-center gap-2 rounded-xl bg-slate-50 px-3 py-2 text-sm font-semibold text-slate-700"
                >
                  <span className="flex h-6 w-6 flex-shrink-0 items-center justify-center rounded-full bg-brand-600 text-xs font-black text-white">
                    {callout.id}
                  </span>
                  <span className="truncate">{callout.label}</span>
                </div>
              ))}
            </div>
            <div className="mt-3 hidden items-center justify-center gap-2 text-xs font-bold uppercase tracking-wider text-slate-400 md:flex">
              {rows.callouts.map((callout, index) => (
                <React.Fragment key={`flow-${callout.id}`}>
                  <span>
                    {callout.id} {callout.label}
                  </span>
                  {index < rows.callouts.length - 1 && (
                    <span className="text-brand-400">→</span>
                  )}
                </React.Fragment>
              ))}
            </div>
          </div>
        </div>

        <aside className="border-t border-slate-200 bg-white p-5 md:p-8 lg:border-l lg:border-t-0">
          <div className="mb-6">
            <div className="text-xs font-bold uppercase tracking-wider text-brand-600">
              Asset Directory
            </div>
            <h4 className="mt-2 text-xl font-black text-slate-900">
              本案例调用的技能资产
            </h4>
          </div>

          <div className="space-y-4">
            <div>
              <div className="mb-3 text-sm font-black text-slate-700">
                流程 / 规则资产
              </div>
              <div className="space-y-3">
                {rows.processAssets.map((asset) => {
                  const Icon = iconMap[asset.kind] || FileText;

                  return (
                    <article
                      key={asset.id}
                      className="rounded-xl border border-slate-200 bg-slate-50 p-4"
                    >
                      <div className="mb-3 flex flex-wrap items-center justify-between gap-2">
                        <div className="flex items-center gap-2">
                          <Icon
                            size={17}
                            className="text-brand-600"
                            strokeWidth={1.8}
                          />
                          <code className="text-sm font-black text-brand-700">
                            {asset.name}
                          </code>
                        </div>
                        <div className="flex flex-wrap gap-1">
                          {(calloutsByAsset[asset.id] || []).map((callout) => (
                            <span
                              key={`${asset.id}-${callout.id}`}
                              className="rounded-full border border-brand-200 bg-white px-2 py-0.5 text-[11px] font-black text-brand-700"
                            >
                              {callout.id} {callout.label}
                            </span>
                          ))}
                        </div>
                      </div>
                      <dl className="space-y-2 text-sm leading-relaxed">
                        <div>
                          <dt className="inline font-bold text-slate-900">
                            资产定位：
                          </dt>
                          <dd className="inline text-slate-600">
                            {asset.position}
                          </dd>
                        </div>
                        <div>
                          <dt className="inline font-bold text-slate-900">
                            本案例用途：
                          </dt>
                          <dd className="inline text-slate-600">
                            {asset.use}
                          </dd>
                        </div>
                        <div>
                          <dt className="inline font-bold text-slate-900">
                            解决问题：
                          </dt>
                          <dd className="inline text-slate-600">
                            {asset.solves}
                          </dd>
                        </div>
                      </dl>
                    </article>
                  );
                })}
              </div>
            </div>

            <div className="border-t border-slate-200 pt-4">
              <div className="mb-3 text-sm font-black text-slate-700">
                命中表资产
              </div>
              <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-1">
                {rows.tableAssets.map((asset) => (
                  <article
                    key={asset.id}
                    className="rounded-xl border border-brand-100 bg-brand-50 p-4"
                  >
                    <div className="mb-2 flex flex-wrap items-center justify-between gap-2">
                      <div className="flex items-center gap-2">
                        <Database
                          size={17}
                          className="text-brand-600"
                          strokeWidth={1.8}
                        />
                        <code className="text-sm font-black text-brand-700">
                          {asset.name}
                        </code>
                      </div>
                      <div className="flex flex-wrap gap-1">
                        {(calloutsByAsset[asset.id] || []).map((callout) => (
                          <span
                            key={`${asset.id}-${callout.id}`}
                            className="rounded-full border border-brand-200 bg-white px-2 py-0.5 text-[11px] font-black text-brand-700"
                          >
                            {callout.id} {callout.label}
                          </span>
                        ))}
                      </div>
                    </div>
                    <div className="text-sm font-bold text-slate-900">
                      {asset.role}
                    </div>
                    <p className="mt-1 text-sm leading-relaxed text-slate-600">
                      {asset.keyFields}
                    </p>
                  </article>
                ))}
              </div>
            </div>
          </div>
        </aside>
      </div>
    </div>
  );
}
