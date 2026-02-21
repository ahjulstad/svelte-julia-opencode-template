module Server

using Oxygen
@oxidize
using HTTP
using LinearAlgebra

@get "/health" function (req::HTTP.Request)
    return json(Dict("status" => "ok"))
end

@get "/eigvals/{n}" function (req::HTTP.Request, n::Int)
    n = clamp(n, 2, 100)
    @info "eigvals request" n
    t = @elapsed begin
        A = randn(n, n)
        vals = sort(real(eigvals(Symmetric(A + A'))))
    end
    @info "eigvals done" n elapsed = round(t, digits=4)
    return json(Dict("matrix_size" => n, "eigenvalues" => vals))
end

end
