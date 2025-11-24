import { Button } from "@/components/ui/button";
import supabase from "@/supabaseClient";

type Props = {
  className?: string;
  size?: "sm" | "default" | "lg" | "icon";
};

export function LogoutButton({ className, size = "sm" }: Props) {
  const handleLogout = async () => {
    try {
      await supabase.auth.signOut();
    } catch (e) {
      console.error("signOut error:", e);
    }
  };

  return (
    <Button
      onClick={handleLogout}
      size={size}
      className={`font-medium transition-colors duration-200 bg-accent hover:bg-aqua-600 ${className ?? ""}`}
    >
      Sign Out
    </Button>
  );
}

export default LogoutButton;
