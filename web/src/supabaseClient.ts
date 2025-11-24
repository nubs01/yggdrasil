import { createClient } from "@supabase/supabase-js";

// Vite env vars (define in .env.local or .env)
// VITE_SUPABASE_URL=...
// VITE_SUPABASE_ANON_KEY=... (or VITE_SUPABASE_PUBLISHABLE_KEY)
const supabaseUrl = import.meta.env.VITE_SUPABASE_URL as string | undefined;
const supabaseAnonKey =
  (import.meta.env.VITE_SUPABASE_ANON_KEY as string | undefined) ??
  (import.meta.env.VITE_SUPABASE_PUBLISHABLE_KEY as string | undefined);

if (!supabaseUrl || !supabaseAnonKey) {
  const message = "Supabase env vars missing. Set VITE_SUPABASE_URL and VITE_SUPABASE_ANON_KEY.";
  console.error(message);
  throw new Error(message);
}

export const supabase = createClient(supabaseUrl, supabaseAnonKey);
export default supabase;
