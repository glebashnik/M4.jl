mutable struct NaiveForecaster <: Forecaster
    seasonal::Bool
end

function predict(forecaster::NaiveForecaster, train_dict, info_dict)
    forecast_dict = SeriesDict()
    
    for (id, y) in train_dict
        info = info_dict[id]
        horizon = info.horizon
        freq = forecaster.seasonal ? info.freq : 1

        y_hat = copy(y)

        for i in 1:horizon
            push!(y_hat, y_hat[end - freq + 1])
        end
    
        forecast_dict[id] = y_hat[end - horizon + 1:end]
    end

    forecast_dict
end
