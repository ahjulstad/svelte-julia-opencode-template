# Dev entrypoint — hot reloads via Revise.
#
# First-time setup (inside server/):
#   julia --project=. -e "using Pkg; Pkg.instantiate()"
#
# Start the dev server:
#   julia --project=server debug.jl
#
# To give OpenCode julia_eval() access via aplavin/julia-mcp:
#   git submodule update --init julia-mcp
#   Then add to your opencode.jsonc:
#     "mcp": {
#       "julia": {
#         "type": "local",
#         "command": ["uv", "run", "--directory", "julia-mcp", "python", "server.py"],
#         "enabled": true
#       }
#     }

using Revise
using Oxygen
using Server

Server.serve(port=8080, revise=:lazy)
