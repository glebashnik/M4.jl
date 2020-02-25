
using Flux
using Zygote: Buffer


struct HoltWintersParams
    level_smooth::Vector{Float64}
    trend_smooth::Vector{Float64}
    season_smooth::Vector{Float64}
    level_start::Vector{Float64}
    trend_start::Vector{Float64}
    season_start::Vector{Float64}
end


struct HoltWintersForecaster <: Forecaster
    params_dict::Dict{String, HoltWintersParams}
end


function OneStepModel(params::HoltWintersParams, train::Series, info::SeriesInfo)
    function(y::Series)
        level_smooth = params.level_smooth[1]
        trend_smooth = params.trend_smooth[1]
        season_smooth = params.season_smooth[1]
        
        n = length(y) + 1
        
        level = Buffer([], Float64, n)
        level[1] = params.level_start[1]
        
        trend = Buffer([], Float64, n)
        trend[1] = params.trend_start[1]

        next = Buffer([], Float64, n)
        next[1] = level[1] + phi * trend[1]

        for t in 2:n
            level[t] = alpha * series[t - 1] + (1 - alpha) * (level[t - 1] + phi * trend[t - 1])
            trend[t] = beta * (level[t] - level[t - 1]) + (1 - beta) * phi * trend[t - 1]
            next[t] = level[t] + phi * trend[t]
        end
        
        copy(next)
    end
end


function predict(forecaster::HoltWintersForecaster, train_dict::SeriesDict, info_dict::SeriesInfoDict)
    for (id, y) in train_dict
        params = forecaster.params_dict[id]
        NextStep
    end    
end


function Loss(model)
    series -> Flux.mse(model(series)[1:end - 1], series[1:end])
end