# test-opencode

SvelteKit frontend + Julia (Oxygen.jl) API server.

## Prerequisites

- Node.js 20+, pnpm
- Julia 1.12+
- uv (for julia-mcp MCP server)

## Setup

```sh
git submodule update --init
pnpm install
julia --project=server -e 'using Pkg; Pkg.instantiate()'
```

## Development

```sh
pnpm run dev
```

Starts both the Vite dev server (`:5173`) and the Julia API server (`:8080`) with hot reload via Revise. Frontend requests to `/api/*` are proxied to the Julia server (the `/api` prefix is stripped).

Other commands:

```sh
pnpm run check     # svelte-check + tsc
pnpm run lint      # ESLint
pnpm run format    # Prettier (write)
pnpm run test      # Vitest
```

## Production

```sh
pnpm run build                            # SvelteKit
julia --project=server server/run.jl      # Julia (no Revise overhead)
```

## Architecture

```
Browser --> Vite (:5173) --> SvelteKit (frontend)
               \--> /api/* proxy --> Oxygen.jl (:8080)

OpenCode --> julia-mcp (stdio MCP) --> persistent Julia REPL
```

## API Endpoints

| Method | Path           | Description                                                     |
| ------ | -------------- | --------------------------------------------------------------- |
| GET    | `/health`      | Health check (`{"status": "ok"}`)                               |
| GET    | `/eigvals/{n}` | Eigenvalues of a random n x n symmetric matrix (n clamped 2..6) |

## Julia MCP

The `julia-mcp` git submodule provides AI agents with `julia_eval()` access via the MCP protocol. Configured in `opencode.jsonc`.
