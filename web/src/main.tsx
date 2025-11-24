import "@fontsource-variable/inter";
import "./index.css";
import React from "react"
import ReactDOM from "react-dom/client";
import App from "./App";
import { ThemeProvider } from "@/components/theme/theme-provider"

ReactDOM.createRoot(document.getElementById("root")!).render(
    <React.StrictMode>
    <App />
    </React.StrictMode>,
);
