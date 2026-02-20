# AGENTS.md

## Stack

TypeScript + Svelte 5, SvelteKit, Tailwind CSS v4, Vitest, pnpm.

## Commands

```bash
pnpm install          # install deps
pnpm run dev          # dev server
pnpm run build        # production build
pnpm run check        # svelte-check + tsc — run after editing TS/Svelte files
pnpm run lint         # ESLint
pnpm run format       # Prettier (write)
pnpm run test         # run all tests
```

## Code Style

- Tabs, single quotes, no trailing commas, 100-char line width (Prettier)
- Named imports; `$lib` alias for `src/lib/`, `$app/*` for SvelteKit runtime
- `camelCase` vars/functions, `PascalCase` components/types, `UPPER_SNAKE_CASE` constants
- Svelte 5 runes: `$state()`, `$derived()`, `$effect()`, `$props()`; `{@render children()}` not `<slot />`
- TypeScript strict mode; avoid `any`, use `unknown`
- SvelteKit error handling: `error()` from `@sveltejs/kit`, never swallow errors silently

## Testing

- Test files in `src/tests/` or co-located as `*.test.ts`
- `@testing-library/svelte` with `render()` and `screen`; jest-dom matchers available globally

## Project Structure

```
src/
  lib/          # shared code ($lib alias)
  routes/       # file-based routing (+page.svelte, +layout.svelte, etc.)
  tests/        # unit/component tests
static/         # public assets
server/         # Julia HTTP server (Oxygen.jl), dev entry: server/debug.jl
julia-mcp/      # git submodule — aplavin/julia-mcp (MCP server for julia_eval)
opencode.jsonc  # OpenCode config — registers julia-mcp as a local MCP tool
```

## Notes

- Never edit `.svelte-kit/` (auto-generated)
- The `julia` MCP tool (from `julia-mcp/`) gives the agent `julia_eval()` access to the running dev server
