import { useEffect } from "react";
import { supabase } from "@/supabaseClient";

export default function DevShell() {
  useEffect(() => {
    if (import.meta.env.DEV) {
      // @ts-expect-error
      window.dev ??= {};
      // @ts-expect-error
      window.dev.supabase = supabase;
      // @ts-expect-error
      window.dev.getUser = async () => {
        const r = await supabase.auth.getUser();
        console.log("getUser ->", r);
        return r;
      };
    }
  }, []);

  return null; // nothing rendered; it's just a loader
}
