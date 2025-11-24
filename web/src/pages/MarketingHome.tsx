// src/pages/MarketingHome.tsx
import { useState } from "react";
import { Button } from "@/components/ui/button"; // or swap for your button
import { Logo } from "@/components/logo";
import LoginButton from "@/components/LoginButton";
import LoginModal from "@/components/LoginModal";
import { ThemeToggle } from "@/components/ThemeToggle";

export default function MarketingHome() {
  const [showLogin, setShowLogin] = useState(false);
  const openLogin = () => setShowLogin(true);

  return (
    <main className="min-h-screen">
      <header className="container mx-auto px-6 py-6 flex items-center justify-between">
        {/* Logo */}
        <Logo />
        <div className="flex items-center space-x-4">
          <LoginButton onOpen={openLogin} />
          <ThemeToggle />
        </div>

        <LoginModal open={showLogin} onClose={() => setShowLogin(false)} />
      </header>

      <section className="container mx-auto px-6 py-16 grid gap-8 md:grid-cols-2 items-center">
        <div>
          <h1 className="text-4xl font-bold">Spice up your car wash sales 🌶️</h1>
          <p className="mt-4 text-muted-foreground">
            AI review replies, upsell scripts, and multi‑site ROI—built for car washes.
          </p>
          <div className="mt-8 flex gap-3">
            <Button onClick={openLogin}>Get started — Free trial</Button>
            <a href="#pricing" className="underline">See pricing</a>
          </div>
        </div>

        <div className="rounded-2xl border p-6">
          <p className="font-medium">What you get</p>
          <ul className="mt-3 list-disc ml-5 text-sm text-muted-foreground space-y-1">
            <li>Unified Google reviews + AI reply drafts</li>
            <li>Membership upsell scripts for attendants</li>
            <li>ROI dashboard across locations</li>
          </ul>
        </div>
      </section>

      <section id="pricing" className="container mx-auto px-6 py-16">
        <h2 className="text-2xl font-semibold">Pricing</h2>
        <div className="grid gap-6 md:grid-cols-3 mt-6">
          {/* Starter */}
          <div className="rounded-2xl border p-6">
            <p className="font-semibold">Starter</p>
            <p className="text-3xl font-bold mt-2">$79</p>
            <p className="text-sm text-muted-foreground">per location / month</p>
            <ul className="mt-4 text-sm space-y-1 list-disc ml-5">
              <li>AI review replies (draft)</li>
              <li>Unified review inbox</li>
              <li>Basic insights</li>
            </ul>
            <Button className="mt-6 w-full" onClick={openLogin}>Start trial</Button>
          </div>

          {/* Pro */}
          <div className="rounded-2xl border p-6">
            <p className="font-semibold">Pro</p>
            <p className="text-3xl font-bold mt-2">$199</p>
            <p className="text-sm text-muted-foreground">per location / month</p>
            <ul className="mt-4 text-sm space-y-1 list-disc ml-5">
              <li>Everything in Starter</li>
              <li>Multi‑site dashboard</li>
              <li>AI upsell scripts</li>
              <li>Competitor promo alerts</li>
            </ul>
            <Button className="mt-6 w-full" onClick={openLogin}>Start trial</Button>
          </div>

          {/* Chain */}
          <div className="rounded-2xl border p-6">
            <p className="font-semibold">Chain</p>
            <p className="text-3xl font-bold mt-2">Custom</p>
            <p className="text-sm text-muted-foreground">volume pricing</p>
            <ul className="mt-4 text-sm space-y-1 list-disc ml-5">
              <li>Everything in Pro</li>
              <li>Campaign & ROI dashboards</li>
              <li>Brand asset library</li>
              <li>SSO & priority support</li>
            </ul>
            <a href="/contact" className="mt-6 inline-block w-full">
              <Button className="w-full">Talk to sales</Button>
            </a>
          </div>
        </div>
      </section>

      <footer className="border-t">
        <div className="container mx-auto px-6 py-10 text-sm text-muted-foreground">
          © {new Date().getFullYear()} Washabi. All rights reserved.
        </div>
      </footer>
    </main>
  );
}
