import { useEffect, useRef, useState } from "react";
import supabase from "@/supabaseClient";
import { DEBUG_AUTH_LOGS } from "@/lib/env";

const dlog = (...args: any[]) => { if (DEBUG_AUTH_LOGS) console.log(...args); };
const derr = (...args: any[]) => { if (DEBUG_AUTH_LOGS) console.error(...args); };
const dwarn = (...args: any[]) => { if (DEBUG_AUTH_LOGS) console.warn(...args); };
const dgroup = (...args: any[]) => { if (DEBUG_AUTH_LOGS && console.groupCollapsed) console.groupCollapsed(...args); };
const dgroupEnd = () => { if (DEBUG_AUTH_LOGS && console.groupEnd) console.groupEnd(); };

function mask(tok?: string) {
  if (!tok) return "(none)";
  return tok.length <= 12 ? tok : `${tok.slice(0, 6)}…${tok.slice(-4)}`;
}
function makeKey(session: any) {
  const uid = session?.user?.id ?? "nouser";
  const rt = (session as any)?.provider_refresh_token ?? "";
  const at = (session as any)?.provider_token ?? "";
  const sig = rt || at || "nosig";
  return `google_writeback:${uid}:${sig.slice(0, 16)}`;
}

export function usePostAuthWriteback(onDone?: () => void) {
  const [writing, setWriting] = useState(false);
  const [error, setError] = useState<string | null>(null);
  const wroteRef = useRef(false);

  async function doWriteback(session: any, source: "EVENT" | "INITIAL") {
    if (!session) return;

    const key = makeKey(session);
    if (wroteRef.current || sessionStorage.getItem(key)) {
      dlog(`[Auth Writeback] (${source}) already wrote for key=${key}; skipping`);
      onDone?.();
      return;
    }

    const providerAccess: string | undefined = (session as any)?.provider_token;
    const providerRefresh: string | undefined = (session as any)?.provider_refresh_token;

    dgroup(`[Auth Writeback] ${source}`);
    dlog("user_id:", session?.user?.id);
    dlog("email:", session?.user?.email);
    dlog("provider_token (masked):", mask(providerAccess));
    dlog("provider_refresh_token (masked):", mask(providerRefresh));

    if (!providerAccess && !providerRefresh) {
      dwarn("[Auth Writeback] No provider tokens on session; nothing to store");
      dgroupEnd();
      onDone?.();
      return;
    }

    try {
      setWriting(true);
      setError(null);

      const googleIdentity = session.user?.identities?.find((i: any) => i.provider === "google");
      const providerUserId =
        googleIdentity?.identity_data?.sub ??
        googleIdentity?.identity_data?.user_id ??
        null;

      const approxAccessExpiryISO = new Date(Date.now() + 60 * 60 * 1000).toISOString();

      dlog("[Auth Writeback] Calling RPC store_google_oauth_tokens ...");
      const { data, error } = await supabase.rpc("store_google_oauth_tokens", {
        p_access_token: providerAccess ?? null,
        p_access_expires_at: approxAccessExpiryISO,
        p_refresh_token: providerRefresh ?? null,
        p_refresh_expires_at: null,
        p_provider_user_id: providerUserId,
        p_scopes: [
            "https://www.googleapis.com/auth/userinfo.email",
            "https://www.googleapis.com/auth/userinfo.profile",
            "https://www.googleapis.com/auth/business.manage",
            "openid",
        ],
      });

      if (error) {
        derr("[Auth Writeback] RPC error:", error);
        throw new Error(error.message);
      }

      dlog("[Auth Writeback] RPC success; returned id:", data);
      sessionStorage.setItem(key, "1");
      wroteRef.current = true;
      dgroupEnd();
      onDone?.();
    } catch (e: any) {
      setError(e?.message ?? "Failed to store provider tokens");
      derr("[Auth Writeback] Failed:", e);
      dgroupEnd();
      onDone?.();
    } finally {
      setWriting(false);
    }
  }

  useEffect(() => {
    const { data: sub } = supabase.auth.onAuthStateChange((event, session) => {
      if (event === "SIGNED_IN" && session) doWriteback(session, "EVENT");
    });

    supabase.auth.getSession().then(({ data }) => {
      if (data.session) doWriteback(data.session, "INITIAL");
    });

    return () => sub.subscription.unsubscribe();
  }, []); // eslint-disable-line react-hooks/exhaustive-deps

  return { writing, error };
}
