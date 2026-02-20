# AGENTS.md

> Instructions for AI coding agents operating in this repository.

## Project Overview

- **Language**: TypeScript + Svelte 5
- **Framework**: SvelteKit (Vite-based)
- **Styling**: Tailwind CSS v4
- **Testing**: Vitest + @testing-library/svelte
- **Linting**: ESLint (flat config) + eslint-plugin-svelte
- **Formatting**: Prettier + prettier-plugin-svelte
- **Package manager**: npm
- **Runtime**: Node.js

## Build Commands

```bash
npm install              # Install dependencies
npm run build            # Production build (vite build)
npm run preview          # Preview production build locally
npm run dev              # Start dev server (vite dev)
npm run dev -- --open    # Start dev server and open browser
npm run prepare          # Sync SvelteKit generated files
```

## Test Commands

```bash
npm run test                              # Run all tests once
npm run test:watch                        # Run tests in watch mode
npm run test:coverage                     # Run tests with coverage

# Run a single test file
npx vitest run src/tests/page.test.ts

# Run tests matching a name pattern
npx vitest run -t "renders the welcome"

# Run tests in a specific directory
npx vitest run src/tests/
```

## Lint / Format / Type Check

```bash
npm run lint             # ESLint (flat config)
npm run format           # Prettier — write fixes
npm run format:check     # Prettier — check only (CI-friendly)
npm run check            # svelte-check + TypeScript type checking
npm run check:watch      # Type checking in watch mode
```

## Code Style Guidelines

### Imports

- Use named imports; avoid wildcard (`*`) imports
- Group imports: third-party packages first, then local modules (`$lib/...`)
- Use the `$lib` alias for anything under `src/lib/` (configured by SvelteKit)
- Use `$app/*` aliases for SvelteKit runtime modules (`$app/navigation`, `$app/stores`, etc.)

### Naming Conventions

- `camelCase` for variables, functions, and props
- `PascalCase` for Svelte components and TypeScript types/interfaces
- `UPPER_SNAKE_CASE` for true constants
- `kebab-case` for CSS classes (Tailwind utility classes are the default)
- SvelteKit file conventions: `+page.svelte`, `+layout.svelte`, `+server.ts`, `+page.ts`, etc.

### Types

- TypeScript strict mode is enabled (`"strict": true` in tsconfig.json)
- Avoid `any`; use `unknown` when the type is uncertain
- Use Svelte 5 `$props()` rune for component props (not the legacy `export let`)
- App-wide types go in `src/app.d.ts` (ambient declarations for `App.Error`, `App.Locals`, etc.)
- Co-locate types with their usage; export shared types from `$lib`

### Error Handling

- Use SvelteKit's `error()` helper from `@sveltejs/kit` in load functions and endpoints
- Never swallow errors silently; propagate or log them
- Use `+error.svelte` pages for user-facing error display
- Server errors belong in `+server.ts` or `+page.server.ts` handlers

### Formatting (Prettier)

- **Tabs** for indentation (not spaces)
- **Single quotes** for strings
- **No trailing commas** in multiline structures
- **100 character** max line width
- Svelte files use the `svelte` parser (via `prettier-plugin-svelte`)
- Config: `.prettierrc`; ignore: `.prettierignore`

### Svelte Components

- Use Svelte 5 runes: `$state()`, `$derived()`, `$effect()`, `$props()`
- Use `{@render children()}` instead of `<slot />`
- Use `<script lang="ts">` for TypeScript in components
- Keep components small; extract reusable logic into `$lib`

## Testing

- Test files live in `src/tests/` or co-located as `*.test.ts` / `*.spec.ts`
- Use `@testing-library/svelte` for component tests with `render()` and `screen`
- The `browser` resolve condition is configured so Svelte client code works in jsdom
- `@testing-library/jest-dom` matchers (e.g., `toHaveTextContent`) are globally available via `vitest-setup.ts`

## Project Structure

```
/workspaces/test-opencode/
├── .devcontainer/           # Dev container configuration
├── src/
│   ├── app.css              # Global styles (Tailwind CSS entry point)
│   ├── app.d.ts             # Ambient TypeScript declarations
│   ├── app.html             # HTML shell template
│   ├── lib/                 # Shared library code ($lib alias)
│   │   ├── assets/          # Static assets imported by components
│   │   └── index.ts         # Library entry point
│   ├── routes/              # SvelteKit file-based routing
│   │   ├── +layout.svelte   # Root layout
│   │   └── +page.svelte     # Home page
│   └── tests/               # Unit/component tests
├── static/                  # Public static assets (served as-is)
├── eslint.config.js         # ESLint flat config
├── svelte.config.js         # Svelte/SvelteKit configuration
├── tsconfig.json            # TypeScript configuration
├── vite.config.ts           # Vite + Vitest configuration
├── vitest-setup.ts          # Vitest global setup (jest-dom matchers)
├── .prettierrc              # Prettier configuration
├── .prettierignore          # Prettier ignore patterns
└── package.json             # Dependencies and scripts
```

## Agent-Specific Notes

- Always run `npm run check` after modifying TypeScript or Svelte files to catch type errors.
- After adding new dependencies, update this file if they introduce new conventions or commands.
- SvelteKit auto-generates files in `.svelte-kit/` — never edit these directly.
- The `$lib` alias resolves to `src/lib/`; use it for all internal imports.
- No CI/CD pipelines are configured yet. No Cursor or Copilot rule files exist.
