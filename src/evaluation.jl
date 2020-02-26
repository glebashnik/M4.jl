using Statistics


abstract type Forecaster 
end


function train!(
    forecaster::T, train_dict::SeriesDict, info_dict::SeriesInfoDict) where T<:Forecaster 
end


function predict(
    forecaster::T, train_dict::SeriesInfoDict, info_dict::SeriesInfoDict)::SeriesDict where T<:Forecaster
end


struct ForecastScore
    smape
    mase
end


const ForecastScoreDict = Dict{String, ForecastScore}


function calc_mae(y, y_hat)
    mean(abs.(y_hat .- y))
end

function calc_smape(y, y_hat)
    200 * mean(abs.(y_hat .- y) ./ (abs.(y_hat) .+ abs.(y)))
end

function calc_mase(y_train, y_test, y_hat, freq)
    y_train_naive = [y_train[i - freq] for i in freq + 1:length(y_train)]
    mae_train_naive = calc_mae(y_train[freq + 1:end], y_train_naive)
    mae_test = calc_mae(y_test, y_hat)
    mae_test / mae_train_naive
end


function split_series(series_dict::SeriesDict, info_dict::SeriesInfoDict)
    train_data = SeriesDict()
    test_data = SeriesDict()

    for (id, y) in series_dict
        info = info_dict[id]
        pivot = length(y) - info.horizon
        train_data[id] = y[1:pivot]
        test_data[id] = y[pivot + 1:end]
    end

    train_data, test_data
end


function evaluate(forecaster::T, train_dict, test_dict, info_dict) where T<:Forecaster
    train!(forecaster, train_dict, info_dict)
    forecast_dict = predict(forecaster, train_dict, info_dict)
    score_dict = ForecastScoreDict()
    
    for id in keys(test_dict)
        info = info_dict[id]
        y_train = train_dict[id]
        y_test = test_dict[id]
        y_hat = forecast_dict[id]

        smape = calc_smape(y_test, y_hat)
        mase = calc_mase(y_train, y_test, y_hat, info.freq)
        score_dict[id] = ForecastScore(smape, mase)
    end

    score_dict
end


function calc_stats(score_dict::ForecastScoreDict)
    scores = values(score_dict)
    smape = mean([s.smape for s in scores])
    mase = mean([s.mase for s in scores])
    ForecastScore(smape, mase)
end