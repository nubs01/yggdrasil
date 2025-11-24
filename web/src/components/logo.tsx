import { useTheme } from "@/components/theme/theme-provider"
import LogoLight from "@/assets/brandmark-low-res-light.png";
import LogoDark from "@/assets/brandmark-low-res-dark.png";

export default function Logo() {
  const { theme } = useTheme();
  let Logo = theme === "light" ? LogoLight : LogoDark;

  return (
    <div className="flex items-center justify-center h-16 px-6 border-border">
      <div className="flex items-center space-x-2">
          <img src={Logo} alt="Logo" className="h-16" />
      </div>
    </div>
  )
}

export { Logo }
