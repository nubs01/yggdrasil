import { Button } from "@/components/ui/button";

type Props = {
  onOpen: () => void;
  className?: string;
  size?: "sm" | "default" | "lg" | "icon";
};

export function LoginButton({ onOpen, className, size = "sm" }: Props) {
  return (
    <Button onClick={onOpen} size={size} className={className}>
      Login
    </Button>
  );
}

export default LoginButton;
