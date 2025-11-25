import { Link, useLocation } from "react-router-dom"
import { Home, MessageSquare, Settings, User, Code } from "lucide-react"
import { cn } from "@/lib/utils"
import { Logo } from "@/components/logo"

const navigation = [
  { name: "Home", href: "/app/home", icon: Home },
  { name: "Account", href: "/app/account", icon: User },
  { name: "Dev", href: "/app/dev", icon: Code },
]

export default function Sidebar() {
  const location = useLocation()

  return (
    <div className="flex flex-col w-64 bg-card border-r border-border">
      {/* Logo */}
      <Logo />

      {/* Navigation */}
      <nav className="flex-1 px-4 py-6 space-y-2">
        {navigation.map((item) => {
          const isActive = location.pathname === item.href
          return (
            <Link
              key={item.name}
              to={item.href}
              className={cn(
                "flex items-center px-4 py-3 text-sm font-medium rounded-lg transition-colors",
                isActive
                  ? "bg-primary text-primary-foreground"
                  : "text-muted-foreground hover:text-foreground hover:bg-accent",
              )}
            >
              <item.icon className="w-5 h-5 mr-3" />
              {item.name}
            </Link>
          )
        })}
      </nav>

      {/* Footer */}
      <div className="p-4 border-t border-border">
        <div className="text-xs text-muted-foreground text-center">Yggdrasil v1.0</div>
      </div>
    </div>
  )
}
