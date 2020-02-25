
using Dates


struct SeriesInfo
    id::String
    category::String
    freq::Int64
    period::String
    horizon::Int64
    start_time::DateTime
end


struct ForecastScore
    smape
    mase
end


const Series = Vector{Float64}
const SeriesDict = Dict{String, Series}
const SeriesInfoDict = Dict{String, SeriesInfo}
const ForecastScoreDict = Dict{String, ForecastScore}


abstract type Forecaster 
end

function train!(
    forecaster::T, train_dict::SeriesDict, info_dict::SeriesInfoDict) where T<:Forecaster 
end

function predict(
    forecaster::T, train_dict::SeriesInfoDict, info_dict::SeriesInfoDict)::SeriesDict where T<:Forecaster
end


struct ForecastWindow
    input::Vector{Float64}
    output::Vector{Float64}
end
