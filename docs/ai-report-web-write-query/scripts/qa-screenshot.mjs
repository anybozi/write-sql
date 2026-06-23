import { mkdir } from "node:fs/promises";
import { fileURLToPath } from "node:url";
import { chromium } from "playwright";

const outputDir = new URL("../qa/", import.meta.url);
await mkdir(outputDir, { recursive: true });

const launchOptions = [
  { headless: true },
  { channel: "chrome", headless: true },
  { channel: "msedge", headless: true },
];

let browser;
let launchError;
for (const options of launchOptions) {
  try {
    browser = await chromium.launch(options);
    break;
  } catch (error) {
    launchError = error;
  }
}

if (!browser) {
  throw launchError;
}

const viewports = [
  { name: "desktop", width: 1440, height: 1200 },
  { name: "mobile", width: 390, height: 900 },
];

const results = [];
for (const viewport of viewports) {
  const page = await browser.newPage({ viewport });
  const consoleErrors = [];
  page.on("console", (message) => {
    if (message.type() === "error") {
      consoleErrors.push(message.text());
    }
  });

  await page.goto("http://127.0.0.1:5173/?qa=1", {
    waitUntil: "networkidle",
  });

  const metrics = await page.evaluate(() => {
    const ids = [
      "hero",
      "pain",
      "architecture",
      "case",
      "assets",
      "roadmap",
      "evidence-clarify",
      "evidence-plan",
      "evidence-sql",
    ];
    const missing = ids.filter((id) => !document.getElementById(id));
    const widthOverflow =
      document.documentElement.scrollWidth -
      document.documentElement.clientWidth;
    const bodyText = document.body.innerText;
    const evidenceOrder = [
      document.getElementById("evidence-clarify")?.getBoundingClientRect().top,
      document.getElementById("evidence-plan")?.getBoundingClientRect().top,
      document.getElementById("evidence-sql")?.getBoundingClientRect().top,
    ];
    return {
      missing,
      widthOverflow,
      hasTitle: bodyText.includes("AI自然语言取数能力底座"),
      hasPositioning: bodyText.includes(
        "将业务自然语言需求，转化为准确、可解释、可校验的 CDAP Hive SQL",
      ),
      hasSixSections:
        document.querySelectorAll("main > section[id]").length === 6,
      hasCorrectMainTable: bodyText.includes("040 全业务号码订单表"),
      hasCorrectBackfill: bodyText.includes("069 全业务资料表"),
      hasClarifications: bodyText.includes("3 个关键澄清问题"),
      hasFourCtas: bodyText.includes("4 段 CTAS"),
      hasSevenChecks: bodyText.includes("7 类自检"),
      hasThreeEvidenceImages:
        document.querySelectorAll("[data-case-evidence] img").length === 3,
      evidenceOrderIsCorrect:
        evidenceOrder.every(Number.isFinite) &&
        evidenceOrder[0] < evidenceOrder[1] &&
        evidenceOrder[1] < evidenceOrder[2],
      hasOldIncorrectScope: bodyText.includes("040+041"),
      hasThreeStages:
        bodyText.includes("能用") &&
        bodyText.includes("好用") &&
        bodyText.includes("复用"),
      scrollHeight: document.documentElement.scrollHeight,
    };
  });

  const screenshotPath = fileURLToPath(
    new URL(`${viewport.name}.png`, outputDir),
  );
  await page.screenshot({ path: screenshotPath, fullPage: true });

  const failedChecks = [
    metrics.missing.length > 0 && `missing: ${metrics.missing.join(", ")}`,
    metrics.widthOverflow !== 0 && `width overflow: ${metrics.widthOverflow}px`,
    !metrics.hasTitle && "missing report title",
    !metrics.hasPositioning && "missing positioning statement",
    !metrics.hasSixSections && "page does not contain six sections",
    !metrics.hasCorrectMainTable && "missing 040 main table",
    !metrics.hasCorrectBackfill && "missing 069 backfill table",
    !metrics.hasClarifications && "missing clarification count",
    !metrics.hasFourCtas && "missing CTAS count",
    !metrics.hasSevenChecks && "missing self-check count",
    !metrics.hasThreeEvidenceImages && "missing evidence screenshots",
    !metrics.evidenceOrderIsCorrect && "evidence order is incorrect",
    metrics.hasOldIncorrectScope && "old 040+041 scope is still visible",
    !metrics.hasThreeStages && "missing three-stage roadmap",
    consoleErrors.length > 0 && `console errors: ${consoleErrors.join(" | ")}`,
  ].filter(Boolean);

  if (failedChecks.length > 0) {
    throw new Error(
      `${viewport.name} QA failed:\n- ${failedChecks.join("\n- ")}`,
    );
  }

  if (viewport.name === "desktop") {
    const caseShotPath = fileURLToPath(
      new URL("case-evidence-desktop.png", outputDir),
    );
    const caseEl = page.locator("#case-evidence-chain");
    if ((await caseEl.count()) > 0) {
      await caseEl.screenshot({ path: caseShotPath });
    }
  }

  results.push({ viewport, consoleErrors, metrics, screenshot: screenshotPath });
  await page.close();
}

await browser.close();
console.log(JSON.stringify(results, null, 2));
