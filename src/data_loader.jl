function read_series(file_path)
    data = SeriesDict()
    is_header = true

    for line in eachline(file_path)
        if is_header
            is_header = false
        else
            parts = split(line, ",")
            parts = map(p->p[2:end - 1], parts)
            id = parts[1]
            values = [parse(Float64, p) for p in parts[2:end] if !isempty(p)]
            data[id] = values
        end
    end

    data
end

function parse_time(value, formats)
    for format in formats
        try 
            return DateTime(value, format)
        catch
            continue
        end
    end
end

function read_info(file_path)
    info_dict = SeriesInfoDict()
    time_formats = [DateFormat("d-m-y H:M"), DateFormat("y-m-d H:M:S")]
    is_header = true

    for line in eachline(file_path)
        if is_header
            is_header = false
        else
            parts = split(line, ",")
            id = parts[1]
            category = parts[2]
            freq = parse(Int8, parts[3])
            period = parts[5]
            horizon = parse(Int8, parts[4])
            start_time = parse_time(parts[6], time_formats)
            info_dict[id] = SeriesInfo(id, category, freq, period, horizon, start_time)
        end
    end

    info_dict
end