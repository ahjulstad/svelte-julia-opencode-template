module Server

using Oxygen
@oxidize
using HTTP
using LinearAlgebra

@get "/health" function (req::HTTP.Request)
    return json(Dict("status" => "ok"))
end

@get "/hello/{name}" function (req::HTTP.Request, name::String)
    return json(Dict("message" => "Hello, $name!"))
end

@get "/eigvals/{n}" function (req::HTTP.Request, n::Int)
    n = clamp(n, 2, 6)
    @info "eigvals request" n
    @info "Test"
    t = @elapsed begin
        A = randn(n, n)
        vals = sort(real(eigvals(Symmetric(A + A'))))
    end
    @info "eigvals done" n t
    return json(Dict("matrix_size" => n, "eigenvalues" => vals))
end

end
