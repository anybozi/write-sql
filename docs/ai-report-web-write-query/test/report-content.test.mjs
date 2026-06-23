import assert from "node:assert/strict";
import { readFile } from "node:fs/promises";
import test from "node:test";

const root = new URL("../", import.meta.url);

async function read(path) {
  return readFile(new URL(path, root), "utf8");
}

test("页面按六章汇报结构组织", async () => {
  const app = [
    await read("src/App.jsx"),
    await read("src/components/ReportSections.jsx"),
  ].join("\n");
  for (const id of [
    "hero",
    "pain",
    "architecture",
    "case",
    "assets",
    "roadmap",
  ]) {
    assert.match(app, new RegExp(`id="${id}"`));
  }
});

test("真实案例严格使用正式对话口径", async () => {
  const content = await read("src/data/reportContent.js");
  assert.match(content, /040 全业务号码订单表/);
  assert.match(content, /069 全业务资料表/);
  assert.match(content, /3 个关键澄清问题/);
  assert.match(content, /4 段 CTAS/);
  assert.match(content, /7 类自检/);
  assert.doesNotMatch(content, /040\+041/);
});

test("三张正式对话截图组成有序证据链", async () => {
  const evidence = await read("src/components/CaseEvidenceChain.jsx");
  assert.match(evidence, /01\.png/);
  assert.match(evidence, /02\.png/);
  assert.match(evidence, /03\.png/);
  assert.match(evidence, /evidence-clarify/);
  assert.match(evidence, /evidence-plan/);
  assert.match(evidence, /evidence-sql/);
});
