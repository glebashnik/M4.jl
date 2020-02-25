using Plots
pyplot()

function plot_pieces(pieces...; gap=false)
    plt = plot(pieces[1], legend=false)
    offset = length(pieces[1])
    last_y = pieces[1][end]
    
    for piece in pieces[2:end]
        x = range(gap ? offset + 1 : offset, stop = offset + length(piece))
        y = gap ? piece : vcat(last_y, piece)
        plot!(plt, x, y)
    end

    plt
end