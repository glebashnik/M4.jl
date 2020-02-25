using StatsBase


function sample_keys(n::Int, dicts::Vararg{Dict})
    common_keys = intersect((collect(keys(d)) for d in dicts)...)
    sample(common_keys, n, replace=false)
end


function sample_dicts(n::Int, dicts::Vararg{Dict})
    sampled_keys = sample_keys(n, dicts...) 
    Tuple(Dict(k => d[k] for k in sampled_keys) for d in dicts)
end


function sample_dicts!(n::Int, dicts::Vararg{Dict})
    sampled_keys = Set(sample_keys(n, dicts...))

    for dict in dicts, key in keys(dict)
        if !(key in sampled_keys)
            delete!(dict, key)
        end
    end
end


function roll_window(y::Vector{Float64}, input_size::Int64, output_size::Int64)
    windows = Vector{Tuple{Vector{Float64}, Vector{Float64}}}()

    for i in input_size:length(y) - output_size
        input = y[i + 1 - input_size:i]
        output = y[i + 1:i + output_size]
        push!(windows, (input,output))
    end

    windows
end
