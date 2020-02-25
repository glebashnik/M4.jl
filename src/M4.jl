module M4

export SeriesDict, SeriesInfo, SeriesInfoDict, Forecaster, predict, train!
export read_series, read_info
export ForecastScore, evaluate, calc_stats
export NaiveForecaster
export plot_pieces

include("types.jl")
include("data_loader.jl")
include("evaluation.jl")
include("prep.jl")
include("naive.jl")
include("plotting.jl")

end
