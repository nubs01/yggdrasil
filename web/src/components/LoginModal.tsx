import { MouseEvent } from "react";
import supabase from "@/supabaseClient";
import { Button } from "@/components/ui/button";
import { useTheme } from "@/components/theme/theme-provider";
import { Auth } from "@supabase/auth-ui-react";
import { ThemeSupa } from "@supabase/auth-ui-shared";
import { Logo } from "@/components/logo";

type Props = { open: boolean; onClose: () => void };

export default function LoginModal({ open, onClose }: Props) {
  const { theme } = useTheme();

  if (!open) return null;

  const stop = (e: MouseEvent<HTMLDivElement>) => e.stopPropagation();

  return (
    <div
      className="fixed inset-0 z-50 flex items-center justify-center bg-black/60 backdrop-blur-sm"
      onClick={onClose}
      role="dialog"
      aria-modal="true"
      aria-labelledby="login-title"
    >
      <div
        className="relative w-full max-w-sm rounded-2xl border bg-card p-6 shadow-xl outline-none animate-in fade-in-0 zoom-in-95
                   dark:border-neutral-800"
        onClick={stop}
      >
        <div className="mb-6 flex items-center gap-3">
          <Logo />
          <div>
            <h2 id="login-title" className="text-lg font-semibold leading-tight">
              Sign in
            </h2>
          </div>
        </div>

        <Auth
          supabaseClient={supabase}
          appearance={{ theme: ThemeSupa }}
          theme={theme === "dark" ? "dark" : "light"}
          view="sign_in"
          providers={[]}
          redirectTo={`${window.location.origin}/app/home`}
        />

        <Button
          variant="secondary"
          className="mt-5 w-full dark:bg-neutral-800 dark:text-neutral-200"
          onClick={onClose}
        >
          Close
        </Button>
      </div>
    </div>
  );
}
