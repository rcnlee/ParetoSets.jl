module ParetoSets

export dominates, naive_pareto
export ParetoSet, pareto_ids, pareto_ys

"""
    dominates(y, y´)

Returns true if y dominates y´, false otherwise.
"""
dominates(y::Vector{Float64}, y´::Vector{Float64}) = all(y .≤ y´) && any(y .< y´)

"""
    naive_pareto{T}(ys::AbstractVector{Vector{T}})

Returns the pareto set of a collection of points ys as a vector of indices into ys.  Uses naive O(n^2) algorithm.
"""
function naive_pareto(ys::AbstractVector{Vector{Float64}})
    pareto_ids = Int[] 
    for (i,y) in enumerate(ys)
        if !any(dominates(y´,y) for y´ in ys)
            push!(pareto_ids, i)
        end
    end
    return pareto_ids
end

mutable struct ParetoSet
    ys::Vector{Vector{Float64}}  #collection of all points
    pareto_ids::Vector{Int}  #vector of indices into full containing pareto set
end
ParetoSet() = ParetoSet(Vector{Float64}[], Int[])

function Base.push!(p::ParetoSet, y::Vector{Float64})
    push!(p.ys, y)
    yi = length(p.ys)
    if !any(dominates(y´, y) for y´ in p.ys)
        push!(p.pareto_ids, yi)
    end
    ids = find(y´->dominates(y,y´), view(p.ys, p.pareto_ids))
    deleteat!(p.pareto_ids, ids)
end

pareto_ids(p::ParetoSet) = p.pareto_ids
pareto_ys(p::ParetoSet) = view(p.ys, p.pareto_ids)

Base.getindex(p::ParetoSet, i) = p.ys[i]
function Base.append!(ps::ParetoSet, ys)
    for y in ys
        push!(ps, y)
    end
end

end # module
