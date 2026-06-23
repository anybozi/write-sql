import {
  AlertTriangle,
  ArrowRight,
  CheckCircle2,
  Clock,
  Database,
  FileCheck2,
  FileCode2,
  GitBranch,
  MessageSquare,
  ShieldCheck,
  Sparkles,
  Users,
} from "lucide-react";
import { AnnotatedCaseShot } from "./components/AnnotatedCaseShot.jsx";
import { caseAge65Demo } from "./data/caseAge65Demo.js";

const navSections = [
  { id: "hero", label: "封面" },
  { id: "pain", label: "背景" },
  { id: "case", label: "案例" },
  { id: "assets", label: "沉淀" },
  { id: "roadmap", label: "规划" },
];

const assetIconMap = {
  entry: FileCode2,
  metric: CheckCircle2,
  table: Database,
  route: GitBranch,
  rule: ShieldCheck,
  case: FileCheck2,
};

const painIconMap = [Users, AlertTriangle, Clock];

/**
 * @param {{ label: string, title: string, desc?: string, inverse?: boolean }} props
 */
function SectionHeader({ label, title, desc, inverse = false }) {
  return (
    <div className="text-center mb-12 md:mb-16">
      <span
        className={
          inverse
            ? "text-brand-400 font-semibold tracking-wider text-sm uppercase"
            : "section-label"
        }
      >
        {label}
      </span>
      <h2
        className={`text-3xl md:text-4xl font-bold mt-2 mb-4 ${
          inverse ? "text-white" : "text-slate-800"
        }`}
      >
        {title}
      </h2>
      {desc ? (
        <p
          className={`text-lg max-w-3xl mx-auto ${
            inverse ? "text-slate-300" : "text-slate-600"
          }`}
        >
          {desc}
        </p>
      ) : null}
      <div className="section-divider" />
    </div>
  );
}

// ─────────────────────────────────────────────────
// 1. 封面
// ─────────────────────────────────────────────────
function HeroSection() {
  return (
    <section
      id="hero"
      className="relative flex min-h-screen items-center justify-center overflow-hidden"
    >
      <div className="absolute inset-0 bg-gradient-to-br from-slate-50 via-white to-brand-50 opacity-70" />
      <div className="absolute left-10 top-20 h-72 w-72 rounded-full bg-brand-200 opacity-20 mix-blend-multiply blur-3xl animate-pulse-slow" />
      <div
        className="absolute bottom-20 right-10 h-96 w-96 rounded-full bg-brand-300 opacity-20 mix-blend-multiply blur-3xl animate-pulse-slow"
        style={{ animationDelay: "1s" }}
      />

      <div className="container relative z-10 mx-auto px-6 py-20 text-center">
        <div className="mb-8 inline-flex animate-fade-in items-center gap-2 rounded-full border border-brand-200 bg-brand-50 px-4 py-2 text-sm font-medium text-brand-700">
          <Sparkles size={16} aria-hidden="true" />
          <span>CDAP 业务数据 · 自然语言取数能力建设</span>
        </div>
        <h1 className="mb-6 animate-slide-up text-4xl font-bold tracking-tight md:text-6xl lg:text-7xl">
          <span className="gradient-text">自然语言取数能力建设</span>
        </h1>
        <p
          className="mx-auto mb-5 max-w-3xl animate-slide-up text-xl font-bold text-slate-700 md:text-2xl"
          style={{ animationDelay: "0.15s" }}
        >
          让业务人员通过自然语言描述需求，自动生成可执行、可校验的取数 SQL
        </p>
        <p
          className="mx-auto mb-10 max-w-3xl animate-slide-up text-lg font-medium text-slate-500 md:text-xl"
          style={{ animationDelay: "0.25s" }}
        >
          把支撑人员的取数经验，沉淀为可复用、可校验的 AI 技能资产
        </p>
        <div
          className="flex animate-slide-up flex-wrap justify-center gap-4"
          style={{ animationDelay: "0.4s" }}
        >
          <a
            href="#pain"
            className="rounded-xl bg-brand-600 px-8 py-4 font-semibold text-white transition-all hover:bg-brand-700 hover:shadow-lg hover:shadow-brand-200"
          >
            为什么做这个
          </a>
          <a
            href="#case"
            className="rounded-xl border-2 border-brand-200 bg-white px-8 py-4 font-semibold text-brand-600 transition-all hover:border-brand-400 hover:bg-brand-50"
          >
            看真实案例
          </a>
        </div>
      </div>
    </section>
  );
}

// ─────────────────────────────────────────────────
// 2. 背景/痛点
// ─────────────────────────────────────────────────
function PainSection() {
  return (
    <section id="pain" className="py-20 md:py-24 bg-white">
      <div className="container mx-auto px-6">
        <div className="max-w-5xl mx-auto">
          <SectionHeader
            label="Why"
            title="为什么要做自然语言取数？"
            desc="CDAP 支撑人员在日常取数中面临三个核心痛点，直接影响了业务响应效率和数据质量。"
          />

          <div className="grid gap-6 md:grid-cols-3 mb-10">
            {caseAge65Demo.painPoints.map((p, i) => {
              const Icon = painIconMap[i] || AlertTriangle;
              return (
                <article
                  key={p.title}
                  className="relative rounded-2xl border border-slate-200 bg-slate-50 p-6 hover-lift"
                >
                  <div className="mb-4 flex h-10 w-10 items-center justify-center rounded-xl bg-brand-100 text-brand-600">
                    <Icon size={20} strokeWidth={1.8} />
                  </div>
                  <h3 className="mb-3 text-lg font-black text-slate-900">
                    {p.title}
                  </h3>
                  <p className="text-sm leading-relaxed text-slate-600">
                    {p.desc}
                  </p>
                </article>
              );
            })}
          </div>

          <div className="rounded-2xl border border-brand-200 bg-brand-50 p-6 text-center">
            <p className="text-lg font-bold text-brand-800">
              把支撑人员的取数经验，沉淀为可复用、可校验的 AI 技能资产，让取数不再依赖个人经验。
            </p>
          </div>
        </div>
      </div>
    </section>
  );
}

// ─────────────────────────────────────────────────
// 3. 案例演示（核心板块）
// ─────────────────────────────────────────────────
function CaseSection() {
  return (
    <section id="case" className="py-20 md:py-24 bg-slate-50">
      <div className="container mx-auto px-6">
        <div className="max-w-6xl mx-auto">
          <SectionHeader
            label="Real Case"
            title="完整案例演示：65 岁以上机主近三个月订单"
            desc="用一个真实案例展示：从一句口语需求，到可执行、可校验的 SQL 交付，全过程如何走通。"
          />

          {/* 3a. 用户原话 */}
          <div className="mb-8 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
            <div className="flex items-start gap-4">
              <div className="flex h-10 w-10 flex-shrink-0 items-center justify-center rounded-full bg-brand-50 text-brand-600">
                <MessageSquare size={20} />
              </div>
              <div>
                <p className="mb-2 text-xs font-semibold uppercase tracking-wider text-slate-400">
                  用户原话
                </p>
                <p className="text-lg font-bold leading-relaxed text-slate-900 md:text-xl">
                  「{caseAge65Demo.userQuery}」
                </p>
              </div>
            </div>
          </div>

          {/* 3b. 需求澄清 + 方案确认 */}
          <div className="mb-8 grid gap-6 md:grid-cols-2">
            <div className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
              <h3 className="mb-4 flex items-center gap-2 text-lg font-black text-slate-900">
                <MessageSquare size={20} className="text-brand-600" />
                需求澄清
              </h3>
              <ul className="space-y-3">
                {caseAge65Demo.clarification.map((item, i) => (
                  <li key={i} className="flex items-start gap-3 text-sm text-slate-700">
                    <CheckCircle2 size={16} className="mt-0.5 flex-shrink-0 text-brand-500" />
                    <span>{item}</span>
                  </li>
                ))}
              </ul>
            </div>

            <div className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
              <h3 className="mb-4 flex items-center gap-2 text-lg font-black text-slate-900">
                <ShieldCheck size={20} className="text-brand-600" />
                方案确认
              </h3>
              <div className="overflow-hidden rounded-xl border border-slate-200">
                <table className="w-full text-left text-sm">
                  <thead>
                    <tr className="bg-slate-50">
                      <th className="w-24 px-4 py-2.5 font-semibold text-slate-500">项</th>
                      <th className="px-4 py-2.5 font-semibold text-slate-500">口径</th>
                    </tr>
                  </thead>
                  <tbody>
                    {caseAge65Demo.planRows.map((row, i) => (
                      <tr
                        key={row.item}
                        className={i % 2 === 0 ? "bg-white" : "bg-slate-50/50"}
                      >
                        <td className="px-4 py-2.5 font-bold text-brand-600">{row.item}</td>
                        <td className="px-4 py-2.5 text-slate-700">{row.value}</td>
                      </tr>
                    ))}
                  </tbody>
                </table>
              </div>
            </div>
          </div>

          {/* 3c. 资产命中 */}
          <div className="mb-8 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
            <h3 className="mb-4 flex items-center gap-2 text-lg font-black text-slate-900">
              <Database size={20} className="text-brand-600" />
              本案例命中的技能资产
            </h3>
            <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {caseAge65Demo.caseAssets.map((asset) => {
                const Icon =
                  asset.role === "运行流程"
                    ? FileCode2
                    : asset.role === "表路由"
                      ? GitBranch
                      : asset.role === "补表规则"
                        ? FileCode2
                        : asset.role === "订单主表" || asset.role === "年龄补表"
                          ? Database
                          : ShieldCheck;

                return (
                  <div
                    key={asset.name}
                    className="rounded-xl border border-slate-200 bg-slate-50 p-4 hover-lift"
                  >
                    <div className="mb-2 flex items-center gap-2">
                      <span className="flex h-7 w-7 items-center justify-center rounded-lg bg-brand-100 text-brand-600">
                        <Icon size={14} strokeWidth={1.8} />
                      </span>
                      <code className="text-xs font-black text-brand-700">{asset.name}</code>
                    </div>
                    <p className="text-xs leading-relaxed text-slate-600">{asset.use}</p>
                  </div>
                );
              })}
            </div>
          </div>

          {/* 3d. 流程走通 */}
          <div className="mb-8 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
            <h3 className="mb-4 flex items-center gap-2 text-lg font-black text-slate-900">
              <GitBranch size={20} className="text-brand-600" />
              取数流程走通
            </h3>
            <div className="grid gap-3 sm:grid-cols-2 lg:grid-cols-3">
              {caseAge65Demo.flowSteps.map((step, index) => (
                <div key={step.title} className="flex gap-3">
                  <div className="flex flex-col items-center">
                    <span className="flex h-7 w-7 flex-shrink-0 items-center justify-center rounded-full bg-brand-600 text-xs font-black text-white">
                      {index + 1}
                    </span>
                    {index < caseAge65Demo.flowSteps.length - 1 && (
                      <div className="mt-1 h-full w-px bg-brand-200" />
                    )}
                  </div>
                  <div className="pb-4">
                    <h4 className="text-sm font-black text-slate-900">{step.title}</h4>
                    <div className="mt-0.5 text-xs text-brand-500">{step.source}</div>
                    <p className="mt-1 text-xs leading-relaxed text-slate-500">{step.desc}</p>
                  </div>
                </div>
              ))}
            </div>
          </div>

          {/* 3e. SQL 交付 */}
          <div className="mb-8 rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
            <h3 className="mb-4 flex items-center gap-2 text-lg font-black text-slate-900">
              <FileCode2 size={20} className="text-brand-600" />
              SQL 交付
            </h3>
            <div className="grid gap-4 md:grid-cols-3 mb-6">
              {caseAge65Demo.sqlSteps.map((s) => (
                <div
                  key={s.step}
                  className="rounded-xl border border-slate-200 bg-slate-50 p-4 hover-lift"
                >
                  <div className="mb-3 flex h-7 w-7 items-center justify-center rounded-full bg-brand-600 text-sm font-bold text-white">
                    {s.step}
                  </div>
                  <code className="mb-1 block text-xs font-mono text-brand-600">{s.table}</code>
                  <h4 className="mb-1 text-sm font-black text-slate-900">{s.title}</h4>
                  <p className="text-xs text-slate-500">{s.desc}</p>
                </div>
              ))}
            </div>

            <div className="mac-window hover-lift">
              <div className="mac-header">
                <div className="mac-dot" style={{ background: "#ff5f56" }} />
                <div className="mac-dot" style={{ background: "#ffbd2e" }} />
                <div className="mac-dot" style={{ background: "#27c93f" }} />
                <span className="ml-2 text-xs text-slate-400">Hive SQL · 关键步骤摘要</span>
              </div>
              <pre className="mac-body">{caseAge65Demo.sqlSnippet}</pre>
            </div>

            <div className="mt-6 rounded-2xl border border-brand-100 bg-brand-50 p-5">
              <div className="mb-3 flex items-center gap-2">
                <ShieldCheck className="text-brand-600" size={18} />
                <h4 className="text-sm font-black text-slate-900">交付附带自检 SQL</h4>
              </div>
              <div className="space-y-2">
                {caseAge65Demo.selfCheck.map((sql) => (
                  <div
                    key={sql}
                    className="flex items-start gap-3 text-sm text-slate-700"
                  >
                    <ArrowRight size={14} className="mt-1 flex-shrink-0 text-brand-500" />
                    <code className="flex-1 rounded-lg border border-slate-200 bg-white px-3 py-1.5 text-xs font-mono">
                      {sql}
                    </code>
                  </div>
                ))}
              </div>
            </div>
          </div>

          {/* 3f. 真实截图证据 */}
          <div className="rounded-2xl border border-slate-200 bg-white p-6 shadow-sm">
            <h3 className="mb-4 flex items-center gap-2 text-lg font-black text-slate-900">
              <FileCheck2 size={20} className="text-brand-600" />
              真实案例截图
            </h3>
            <AnnotatedCaseShot annotations={caseAge65Demo.annotations} />
          </div>
        </div>
      </div>
    </section>
  );
}

// ─────────────────────────────────────────────────
// 4. 能力沉淀
// ─────────────────────────────────────────────────
function AssetsSection() {
  return (
    <section id="assets" className="py-20 md:py-24 bg-white">
      <div className="container mx-auto px-6">
        <div className="max-w-5xl mx-auto">
          <SectionHeader
            label="Assets"
            title="我们沉淀了什么"
            desc="把支撑人员的取数经验，拆解为可调用、可维护的标准化资产。"
          />

          {/* 统计卡片 */}
          <div className="grid gap-4 md:grid-cols-3 mb-12">
            <div className="rounded-2xl border border-slate-200 bg-slate-50 p-6 text-center hover-lift">
              <div className="mb-2 text-4xl font-black text-brand-600">
                {caseAge65Demo.assetStats.tables}
              </div>
              <div className="text-sm font-semibold text-slate-700">张表文档</div>
              <p className="mt-1 text-xs text-slate-500">含字段、分区、粒度、关联说明</p>
            </div>
            <div className="rounded-2xl border border-slate-200 bg-slate-50 p-6 text-center hover-lift">
              <div className="mb-2 text-4xl font-black text-brand-600">
                {caseAge65Demo.assetStats.metrics}
              </div>
              <div className="text-sm font-semibold text-slate-700">个标准指标</div>
              <p className="mt-1 text-xs text-slate-500">含 ID、名称、口径、来源表</p>
            </div>
            <div className="rounded-2xl border border-slate-200 bg-slate-50 p-6 text-center hover-lift">
              <div className="mb-2 text-4xl font-black text-brand-600">
                {caseAge65Demo.assetStats.cases}
              </div>
              <div className="text-sm font-semibold text-slate-700">个验证案例</div>
              <p className="mt-1 text-xs text-slate-500">可复用路径，加速相似需求</p>
            </div>
          </div>

          {/* 资产类型卡片 */}
          <h3 className="mb-6 text-center text-lg font-black text-slate-800">
            七大核心资产类型
          </h3>
          <div className="grid gap-4 sm:grid-cols-2 lg:grid-cols-3">
            {caseAge65Demo.assetTypes.map((asset) => {
              const Icon = assetIconMap[asset.kind] || FileCode2;
              return (
                <article
                  key={asset.name}
                  className="rounded-2xl border border-slate-200 bg-slate-50 p-5 hover-lift"
                >
                  <div className="mb-3 flex items-center gap-3">
                    <div className="flex h-9 w-9 flex-shrink-0 items-center justify-center rounded-xl bg-brand-100 text-brand-600">
                      <Icon size={17} strokeWidth={1.8} />
                    </div>
                    <div>
                      <code className="text-xs font-black text-brand-700">{asset.name}</code>
                      <h4 className="text-sm font-bold text-slate-900">{asset.title}</h4>
                    </div>
                  </div>
                  <p className="text-xs leading-relaxed text-slate-600">{asset.desc}</p>
                </article>
              );
            })}
          </div>
        </div>
      </div>
    </section>
  );
}

// ─────────────────────────────────────────────────
// 5. 下一步规划
// ─────────────────────────────────────────────────
function RoadmapSection() {
  return (
    <section id="roadmap" className="py-20 md:py-24 bg-slate-800">
      <div className="container mx-auto px-6">
        <div className="max-w-4xl mx-auto">
          <SectionHeader
            label="Roadmap"
            title="下一步计划"
            desc="从辅助取数到自助取数，逐步让业务人员零门槛使用。"
            inverse
          />

          <div className="grid gap-6 md:grid-cols-3">
            {caseAge65Demo.roadmap.map((item, i) => (
              <div
                key={item.phase}
                className="relative rounded-2xl border border-slate-700 bg-slate-900 p-6 hover-lift"
              >
                <span className="absolute right-5 top-5 text-4xl font-black text-brand-900/30">
                  {String(i + 1).padStart(2, "0")}
                </span>
                <div className="mb-3 inline-flex rounded-full bg-brand-600/20 px-3 py-1 text-xs font-bold text-brand-400">
                  {item.phase}
                </div>
                <h3 className="mb-3 text-lg font-black text-white">{item.label}</h3>
                <ul className="space-y-2">
                  {item.items.map((li) => (
                    <li key={li} className="flex items-start gap-2 text-sm text-slate-300">
                      <ArrowRight size={14} className="mt-1 flex-shrink-0 text-brand-400" />
                      <span>{li}</span>
                    </li>
                  ))}
                </ul>
              </div>
            ))}
          </div>
        </div>
      </div>
    </section>
  );
}

// ─────────────────────────────────────────────────
// App
// ─────────────────────────────────────────────────
export function App() {
  return (
    <div className="bg-slate-50 text-slate-800 font-sans antialiased">
      {/* 右侧导航点 */}
      <nav
        className="fixed right-4 top-1/2 z-40 hidden -translate-y-1/2 flex-col gap-3 md:right-6 lg:flex"
        aria-label="页面章节导航"
      >
        {navSections.map((s, i) => (
          <a
            key={s.id}
            href={`#${s.id}`}
            title={s.label}
            className={`h-3 w-3 rounded-full transition-colors ${
              i === 0
                ? "scale-125 bg-brand-600"
                : "bg-slate-300 hover:bg-brand-600"
            }`}
          />
        ))}
      </nav>

      <HeroSection />
      <PainSection />
      <CaseSection />
      <AssetsSection />
      <RoadmapSection />

      {/* Footer */}
      <footer className="bg-slate-900 py-12 text-center">
        <div className="container mx-auto px-6">
          <p className="mb-4 text-sm text-slate-400">
            write-query 技能 · CDAP 自然语言取数能力底座
          </p>
          <div className="inline-flex flex-wrap items-center justify-center gap-2 rounded-full bg-slate-800 px-6 py-3 text-sm font-bold text-white md:gap-4">
            <span>懂需求</span>
            <ArrowRight size={14} className="text-slate-500" />
            <span>找对表</span>
            <ArrowRight size={14} className="text-slate-500" />
            <span>补字段</span>
            <ArrowRight size={14} className="text-slate-500" />
            <span>自检</span>
            <ArrowRight size={14} className="text-brand-500" />
            <span className="text-brand-400">交付 SQL</span>
          </div>
        </div>
      </footer>
    </div>
  );
}