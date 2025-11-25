// src/pages/MarketingHome.tsx
import { useState } from "react";
import { Logo } from "@/components/logo";
import LoginButton from "@/components/LoginButton";
import LoginModal from "@/components/LoginModal";
import { ThemeToggle } from "@/components/ThemeToggle";
import "@/styles/marketing.css";

export default function MarketingHome() {
  const [showLogin, setShowLogin] = useState(false);
  const openLogin = () => setShowLogin(true);

  return (
    <main className="marketing-shell min-h-screen">
      <div className="content">
        <header className="container mx-auto px-6 py-6 flex items-center justify-between">
          <Logo />
          <div className="flex items-center gap-4">
            <LoginButton onOpen={openLogin} />
            <ThemeToggle />
          </div>
          <LoginModal open={showLogin} onClose={() => setShowLogin(false)} />
        </header>

        <section className="container mx-auto px-6 pb-16 pt-4">
          <div className="hero-grid grid items-center gap-10 md:grid-cols-[1.1fr_1fr]">
            <div className="space-y-6">
              <div className="hero-pill">
                <span className="dot">◎</span>
                A friendlier loom for the tapestry of your life
              </div>

              <div className="space-y-4">
                <h1 className="text-4xl font-bold leading-tight md:text-[2.7rem] md:leading-[1.1] text-foreground">
                  Weave your own world-tree of people —{" "}
                  <span className="highlight">watch the branches and threads connect worlds.</span>
                </h1>
                <p className="text-base md:text-lg text-foreground/80 max-w-3xl">
                  <strong className="text-foreground">Yggdrasil</strong> helps you remember, nurture,
                  and rediscover the people in your orbit. Turn scattered notes, half-forgotten
                  intros, and the “Wait… how did I meet them again?” moments into a living network
                  of relationships. Think of it as your personal world-tree: part social map, part memory
                  spell, part cosmic loom — minus the actual Norns, Fates, or Shai scribbling ominously
                  in the margins.
                </p>
              </div>

              <div className="flex flex-wrap items-center gap-3">
                <button className="cta-primary" onClick={openLogin}>
                  Start weaving your web <span className="text-base">↗</span>
                </button>
                <a className="cta-secondary" href="#features">
                  See how the threads connect
                </a>
              </div>

              <div className="flex flex-wrap gap-2">
                <span className="meta-chip">graph_native = true</span>
                <span className="meta-chip">api_first = true</span>
                <span className="meta-chip">storage.engine = "relationships"</span>
              </div>

              <div className="space-y-1 text-sm text-foreground/75">
                <p>
                  No mysticism required. Just a playful way to track who’s who, who knows who,
                  and who you were <em>totally</em> supposed to introduce last month.
                </p>
                <p className="text-foreground/60">
                  Not fate. Not prophecy. Just a beautifully organized way to keep the right people close—and keep your worlds connected.
                </p>
              </div>
            </div>

            <aside className="graph-card">
              <div className="flex items-center justify-between text-sm text-foreground/75 mb-4">
                <div className="flex items-center gap-2">
                  <span className="h-2 w-2 rounded-full bg-accent shadow-[0_0_10px_rgba(88,164,176,0.9)]" />
                  <span>Connections around “You” — the root of your personal world-tree</span>
                </div>
                <div className="hidden sm:flex items-center gap-2 rounded-full border border-border/60 px-3 py-1 text-xs bg-background/40">
                  <span>Search the tapestry…</span>
                  <span className="rounded-md border border-border/80 px-1.5 py-0.5 font-mono text-[10px] text-foreground/80">⌘K</span>
                </div>
              </div>

              <div className="relative h-64">
                <span className="graph-edge glow" style={{ left: "50%", top: "50%", width: "180px", transform: "translate(0, -2px) rotate(-18deg)" }} />
                <span className="graph-edge" style={{ left: "22%", top: "36%", width: "120px", transform: "rotate(12deg)" }} />
                <span className="graph-edge" style={{ left: "50%", top: "50%", width: "150px", transform: "translate(0, -2px) rotate(155deg)" }} />
                <span className="graph-edge glow" style={{ left: "45%", top: "55%", width: "160px", transform: "translate(0, -2px) rotate(25deg)" }} />
                <span className="graph-edge" style={{ left: "55%", top: "52%", width: "80px", transform: "translate(0, -2px) rotate(-80deg)" }} />

                <div className="graph-node main" style={{ left: "50%", top: "50%", transform: "translate(-50%, -50%)" }}>
                  <span className="graph-avatar">you</span>
                  <span>You</span>
                  <span className="graph-pill">keeper of many threads</span>
                </div>

                <div className="graph-node" style={{ left: "12%", top: "22%" }}>
                  <span className="graph-avatar">A</span>
                  <span>Aisha</span>
                  <span className="graph-pill">met during an academic quest</span>
                </div>

                <div className="graph-node" style={{ right: "10%", top: "30%" }}>
                  <span className="graph-avatar">M</span>
                  <span>Marcus</span>
                  <span className="graph-pill">ask about runic-grade database magic</span>
                </div>

                <div className="graph-node" style={{ left: "6%", bottom: "12%" }}>
                  <span className="graph-avatar">P</span>
                  <span>Pooja</span>
                  <span className="graph-pill">shared adventures in clinicland</span>
                </div>

                <div className="graph-node" style={{ right: "16%", bottom: "14%" }}>
                  <span className="graph-avatar">S</span>
                  <span>Sophia</span>
                  <span className="graph-pill">introduced by wandering messenger</span>
                </div>

                <div className="graph-node" style={{ left: "52%", top: "16%" }}>
                  <span className="graph-avatar">✶</span>
                  <span>“Boston founders” — a small guild</span>
                </div>
              </div>

              <div className="mt-6 flex flex-wrap items-center justify-between gap-3 text-xs text-foreground/80">
                <div className="flex flex-wrap gap-2">
                  <span className="meta-chip bg-background/40">142 threads woven</span>
                  <span className="meta-chip bg-background/40">389 bonds recorded</span>
                  <span className="meta-chip bg-background/40">27 fateful introductions foretold</span>
                </div>
                <span className="rounded-full border border-accent/60 bg-background/50 px-3 py-1 text-primary">
                  🌿 Story mode — view the saga
                </span>
              </div>
            </aside>
          </div>
        </section>

        <section id="features" className="container mx-auto px-6 pb-16">
          <div className="rounded-2xl border border-border/60 bg-card/70 p-8 shadow-2xl shadow-black/40 backdrop-blur-md">
            <p className="text-lg font-semibold text-foreground">What you get</p>
            <ul className="mt-3 list-disc pl-5 text-sm text-foreground/80 space-y-2">
              <li>Lightning-fast person lookup with nicknames, tags, and life events</li>
              <li>Relationship graph that maps who-knows-who (and how well)</li>
              <li>Memory joggers: favorite drinks, big wins, pet names, and conversation hooks</li>
              <li>Smart queries like “people I met in Lisbon who know Sam”</li>
              <li>No pricing. No pressure. Just log in and start remembering.</li>
            </ul>
          </div>
        </section>

        <footer className="border-t border-white/10">
          <div className="container mx-auto px-6 py-10 text-sm text-slate-200/70">
            © {new Date().getFullYear()} Yggdrasil. Remember people like a legend.
          </div>
        </footer>
      </div>
    </main>
  );
}
