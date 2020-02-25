
using Flux
using Zygote: Buffer


struct HoltWinters
    input_size::Int64
    output_size::Int64
    freq::Int64
    
    level_smooth::Vector{Float64}
    trend_smooth::Vector{Float64}
    season_smooth::Vector{Float64}
    
    level_init::Vector{Float64}
    trend_init::Vector{Float64}
    season_init::Vector{Float64}
end


function HoltWinters(input_size, output_size, freq)
    level_smooth = [0.5]
    trend_smooth = [0.5]
    season_smooth = [0.5]
    
    level_init = [0.5]
    trend_init = [0.5]
    season_init = repeat([0.5], freq)

    HoltWinters(
        input_size, output_size, freq, 
        level_smooth, trend_smooth, season_smooth, 
        level_init, trend_init, season_init)    
end
    

function (model::HoltWinters)(input::Vector{Float64})
    level_smooth = model.level_smooth[1]
    trend_smooth = model.level_smooth[1]
    season_smooth = model.season_smooth[1]

    level = Buffer([], Float64, model.input_size)
    trend = Buffer([], Float64, model.input_size)
    season = Buffer([], Float64, model.input_size)

    for t in 1:model.input_size
        level_prev = t == 1 ? model.level_init[1] : level[t - 1]
        trend_prev = t == 1 ? model.trend_init[1] : trend[t - 1]
        season_prev = t <= model.freq ? model.season_init[t] : season[t - model.freq]
        
        level[t] = (level_smooth * (input[t] - season_prev) 
            + (1 - level_smooth) * (level_prev + trend_prev))
        
        trend[t] = (trend_smooth * (level[t] - level_prev) 
            + (1 - trend_smooth) * trend_prev)
        
        season[t] = (season_smooth * (input[t] - level_prev - trend_prev) 
            + (1 - season_smooth) * season_prev)
    end
    
    pred = Buffer([], Float64, model.output_size)
    
    for h in 1:model.output_size
        k = floor(Int64, (h - 1) / model.freq)
        
        pred[h] = (level[model.input_size] 
            + h * trend[model.input_size] 
            + season[model.input_size + h - model.freq * (k + 1)])
    end
    
    copy(pred)
end


#model = HoltWinters(input_size, output_size, info.freq)
#model(windows[2][1])