# Production entrypoint — no Revise overhead.
#
# Run with:
#   julia --project=. run.jl

include("src/Server.jl")
using .Server

Server.serve(port=8080)
