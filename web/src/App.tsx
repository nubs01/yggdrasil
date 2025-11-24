// src/App.tsx
import "./index.css";
import { BrowserRouter as Router, Routes, Route, Navigate } from "react-router-dom";
import { ThemeProvider } from "@/components/theme/theme-provider";

import { AuthProvider } from "@/auth/AuthProvider";
import ProtectedRoute from "@/auth/ProtectedRoute";
import PublicOnlyRoute from "@/auth/PublicOnlyRoute";

import Layout from "@/components/Layout";
import MarketingHome from "@/pages/MarketingHome";   // NEW
import Home from "@/pages/Home";
import Account from "@/pages/Account";
import DevShell from "@/pages/DevShell"; // Optional
import NotFound from "@/pages/NotFound"; // Optional

function App() {
  return (
    <ThemeProvider defaultTheme="light" storageKey="review-app-theme">
      <AuthProvider>
        <Router>
          <Routes>
            {/* Public marketing site (logged-out only) */}
            <Route
              path="/"
              element={
                <PublicOnlyRoute>
                  <MarketingHome />
                </PublicOnlyRoute>
              }
            />

            {/* App routes (logged-in only) */}
            <Route
              path="/app"
              element={
                <ProtectedRoute>
                  <Layout />
                </ProtectedRoute>
              }
            >
              <Route index element={<Navigate to="home" replace />} />

              {/* Choose your app start page; here we keep your original pages */}
              <Route path="home" element={<Home />} />
              <Route path="account" element={<Account />} />
              <Route path="dev" element={<DevShell />} />
              {/* Optional: default logged-in redirect */}
              <Route index element={<Home />} />
              <Route path="*" element={<NotFound />} />
            </Route>
          </Routes>
        </Router>
      </AuthProvider>
    </ThemeProvider>
  );
}

export default App;
