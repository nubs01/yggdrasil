// src/auth/PublicOnlyRoute.tsx
import { Navigate } from "react-router-dom";
import { useAuth } from "./AuthProvider";

export default function PublicOnlyRoute({ children }: { children: JSX.Element }) {
  const { loading, session } = useAuth();
  if (loading) return null; // or a spinner
  if (session) return <Navigate to="/app/home" replace />;
  return children;
}
