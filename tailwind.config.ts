import type { Config } from "tailwindcss";

const config: Config = {
  content: [
    "./app/**/*.{js,ts,jsx,tsx,mdx}",
    "./pages/**/*.{js,ts,jsx,tsx,mdx}",
    "./components/**/*.{js,ts,jsx,tsx,mdx}",
    "./src/**/*.{js,ts,jsx,tsx,mdx}",
  ],
  theme: {
    extend: {
      colors: {
        navy: "#102A43",
        teal: "#16B8A6",
        sky: "#46A6FF",
        sand: "#F5F1E8",
        ink: "#15202B",
        success: "#20A66A",
        warning: "#E9A23B",
        danger: "#D74D4D",
        border: "#D9E2EC",
        muted: "#627D98",
      },
      fontFamily: {
        sans: ["Manrope", "Plus Jakarta Sans", "Arial", "sans-serif"],
      },
      borderRadius: {
        sm: "0.5rem",
        md: "0.75rem",
        lg: "1rem",
        xl: "1.5rem",
      },
      boxShadow: {
        sm: "0 1px 3px rgb(16 42 67 / 0.08)",
        md: "0 8px 24px rgb(16 42 67 / 0.12)",
      },
    },
  },
  plugins: [],
};

export default config;
