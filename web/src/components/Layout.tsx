import type { ReactNode } from "react"
import { useLocation } from "react-router-dom"
import Sidebar from "./Sidebar"
import Topbar from "./Topbar"
import { Outlet } from "react-router-dom";


const getPageTitle = (pathname: string): string => {
  switch (pathname) {
    case "/app/home":
      return "Dashboard"
    case "/app/account":
      return "Account"
    case "/app/dev":
        return "Dev"
    default:
      return "Dashboard"
  }
}

export default function Layout() {
  const location = useLocation()
  const pageTitle = getPageTitle(location.pathname)

  return (
    <div className="flex h-screen bg-background">
      {/* Sidebar */}
      <Sidebar />

      {/* Main Content */}
      <div className="flex-1 flex flex-col overflow-hidden">
        {/* Topbar */}
        <Topbar title={pageTitle} />

        {/* Page Content */}
        <main className="flex-1 overflow-auto p-6"><Outlet /></main>
      </div>
    </div>
  )
}
