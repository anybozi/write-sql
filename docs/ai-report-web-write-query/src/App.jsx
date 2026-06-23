import { useEffect, useState } from "react";
import { ArrowRight } from "lucide-react";
import {
  ArchitectureSection,
  AssetsSection,
  CaseSection,
  HeroSection,
  PainSection,
  RoadmapSection,
} from "./components/ReportSections.jsx";

const navSections = [
  { id: "hero", label: "项目定位" },
  { id: "pain", label: "背景痛点" },
  { id: "architecture", label: "运行流程与架构" },
  { id: "case", label: "真实案例" },
  { id: "assets", label: "技能资产" },
  { id: "roadmap", label: "下一步规划" },
];

function usePageObservers() {
  const [activeSection, setActiveSection] = useState("hero");

  useEffect(() => {
    const revealObserver = new IntersectionObserver(
      (entries) => {
        entries.forEach((entry) => {
          if (entry.isIntersecting) entry.target.classList.add("is-visible");
        });
      },
      { threshold: 0.12 },
    );

    const sectionObserver = new IntersectionObserver(
      (entries) => {
        const visible = entries
          .filter((entry) => entry.isIntersecting)
          .sort((a, b) => b.intersectionRatio - a.intersectionRatio)[0];
        if (visible) setActiveSection(visible.target.id);
      },
      { rootMargin: "-30% 0px -55% 0px", threshold: [0, 0.2, 0.5] },
    );

    const revealItems = document.querySelectorAll(".reveal");
    const sections = document.querySelectorAll("main > section[id]");
    revealItems.forEach((item) => revealObserver.observe(item));
    sections.forEach((section) => sectionObserver.observe(section));

    return () => {
      revealObserver.disconnect();
      sectionObserver.disconnect();
    };
  }, []);

  return activeSection;
}

export function App() {
  const activeSection = usePageObservers();
  const qaMode = new URLSearchParams(window.location.search).has("qa");

  useEffect(() => {
    if (!qaMode) return undefined;
    const previous = document.documentElement.style.scrollBehavior;
    document.documentElement.style.scrollBehavior = "auto";
    return () => {
      document.documentElement.style.scrollBehavior = previous;
    };
  }, [qaMode]);

  return (
    <div className={`page-shell ${qaMode ? "qa-mode" : ""}`}>
      <nav className="chapter-nav" aria-label="汇报章节导航">
        {navSections.map((section, index) => (
          <a
            key={section.id}
            href={`#${section.id}`}
            title={section.label}
            aria-label={`跳转到${section.label}`}
            aria-current={activeSection === section.id ? "location" : undefined}
            className={activeSection === section.id ? "is-active" : ""}
          >
            <span>{String(index + 1).padStart(2, "0")}</span>
            <i />
            <strong>{section.label}</strong>
          </a>
        ))}
      </nav>

      <main>
        <HeroSection />
        <PainSection />
        <ArchitectureSection />
        <CaseSection />
        <AssetsSection />
        <RoadmapSection />
      </main>

      <footer className="report-footer">
        <p>write-query 技能 · CDAP AI 自然语言取数能力底座</p>
        <div>
          <span>懂需求</span>
          <ArrowRight size={13} />
          <span>找对表</span>
          <ArrowRight size={13} />
          <span>补字段</span>
          <ArrowRight size={13} />
          <span>自检</span>
          <ArrowRight size={13} />
          <strong>交付 SQL</strong>
        </div>
      </footer>
    </div>
  );
}
