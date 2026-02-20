# Dev entrypoint — hot reloads via Revise.
#
# First-time setup (inside server/):
#   julia --project=. -e "using Pkg; Pkg.instantiate()"
#
# Start the dev server:
#   julia --project=. debug.jl
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
# Revise will be picked up automatically if it is in your global Julia environment.

using Revise
using Oxygen
include("src/Server.jl")
using .Server

Server.serve(port=8080, revise=:eager)
