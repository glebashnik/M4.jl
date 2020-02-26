using StatsBase
using Flux


function sample_keys(n, dicts...)
    common_keys = intersect((collect(keys(d)) for d in dicts)...)
    sample(common_keys, n, replace=false)
end


function sample_dicts(n, dicts...)
    sampled_keys = sample_keys(n, dicts...) 
    Tuple(Dict(k => d[k] for k in sampled_keys) for d in dicts)
end


function sample_dicts!(n, dicts...)
    sampled_keys = Set(sample_keys(n, dicts...))

    for dict in dicts, key in keys(dict)
        if !(key in sampled_keys)
            delete!(dict, key)
        end
    end
end


function roll_window(series, input_size, output_size)
    inputs = Vector()
    outputs = Vector()
     
    for i in input_size:length(series) - output_size
        push!(inputs, series[i + 1 - input_size:i])
        push!(outputs, series[i + 1:i + output_size])
    end

    reduce(hcat, inputs), reduce(hcat, outputs)
end
