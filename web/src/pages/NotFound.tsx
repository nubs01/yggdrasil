// src/pages/NotFound.tsx
import { Link } from "react-router-dom";

export default function NotFound() {
  return (
    <main className="min-h-screen flex flex-col items-center justify-center text-center p-6">
      <h1 className="text-5xl font-bold">404</h1>
      <p className="mt-4 text-lg text-muted-foreground">
        Oops! The page you’re looking for doesn’t exist.
      </p>
      <Link
        to="/"
        className="mt-6 px-4 py-2 rounded-lg bg-primary text-primary-foreground hover:opacity-90"
      >
        Go back home
      </Link>
    </main>
  );
}
