using ParetoSets
@static if VERSION < v"0.7.0-DEV.2005"
    using Base.Test
else
    using Test
end

# write your own tests here
let
    x = [0.5, 0.5] 
    y = [1.0, 2.0] 
    z = [1.5, 1.5] 
    
    @test dominates(x, y)
    @test !dominates(y, x)
    @test dominates(x, z)
    @test !dominates(z, x)
    @test !dominates(y, z)
    @test !dominates(z, y)
end

let
    x = [0.01, 0.02]
    y = [0.02, 0.01]
    v = Vector{Float64}[]
    push!(v, x)
    push!(v, y)
    for i = 1:8
        push!(v, rand(2) .+ 0.02)
    end
    ids = naive_pareto(v)
    @test ids == [1, 2]

    ps = ParetoSet()
    push!(ps, v[1])
    @test pareto_ids(ps) == [1]
    @test pareto_ys(ps) == [x]
    push!(ps, v[2])
    @test pareto_ids(ps) == [1,2]
    @test pareto_ys(ps) == [x,y]
    append!(ps, v[3:end])
    @test pareto_ids(ps) == [1,2]
    @test pareto_ys(ps) == [x,y]
    @test pareto_ids(ps) == naive_pareto(v)
    @test dominated_ids(ps) == collect(3:length(v))
    @test dominated_ys(ps) == v[3:end]
end
