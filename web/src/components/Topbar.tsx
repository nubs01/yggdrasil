import { useEffect, useState } from "react";
import { useAuth } from "@/auth/AuthProvider";
import { ThemeToggle } from "./ThemeToggle";
import LoginButton from "./LoginButton";
import LogoutButton from "./LogoutButton";
import LoginModal from "./LoginModal";

interface TopbarProps {
  title: string;
}

export default function Topbar({ title }: TopbarProps) {
  const { session, loading } = useAuth();
  const [showLogin, setShowLogin] = useState(false);

  useEffect(() => {
    if (session) setShowLogin(false);
  }, [session]);

  return (
    <header className="flex items-center justify-between h-16 px-6 bg-card border-b border-border">
      <div className="flex items-center">
        <h1 className="text-2xl font-bold text-foreground">{title}</h1>
      </div>

      <div className="flex items-center space-x-4">
        {!loading && (session ? <LogoutButton /> : <LoginButton onOpen={() => setShowLogin(true)} />)}
        <ThemeToggle />
      </div>

      <LoginModal open={showLogin} onClose={() => setShowLogin(false)} />
    </header>
  );
}
