# Production entrypoint — no Revise overhead.
#
# Run with:
#   julia --project=server run.jl

using Server

serve(port=8080)
