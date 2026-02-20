module Server

using Oxygen
using HTTP
using LinearAlgebra

export serve

# Routes are registered inside serve() rather than at module top-level.
# This avoids the Julia precompilation problem: @get macros at module scope run
# during precompilation and register routes into a snapshot of Oxygen.CONTEXT that
# is discarded at runtime. Registering inside serve() ensures routes are always
# added into the live runtime context.
function serve(; kwargs...)
    @get "/health" function (req::HTTP.Request)
        return json(Dict("status" => "ok"))
    end

    @get "/eigvals/{n}" function (req::HTTP.Request, n::Int)
        n = clamp(n, 2, 6)
        @info "eigvals request" n
        t = @elapsed begin
            A = randn(n, n)
            vals = sort(real(eigvals(Symmetric(A + A'))))
        end
        @info "eigvals done" n elapsed = round(t, digits = 4)
        return json(Dict("matrix_size" => n, "eigenvalues" => vals))
    end

    Oxygen.serve(; kwargs...)
end

end
