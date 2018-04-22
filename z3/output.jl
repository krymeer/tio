using DataFrames, Gadfly

# Generowanie wykresu na podstawie uzyskanych wynikow. Przedstawiane sa wartosci najlepszego
# i najgorszego rozwiazania z danej populacji, a takze srednia calej generacji
function createchart(bvarray::Array{Int64,1}, wvarray::Array{Int64,1}, avarray::Array{Float64,1}, c1::Float64, c2::Float64, c3::Float64)
    n       = length(bvarray)
    ymax    = maximum(bvarray)+5
    xmax    = n+5
    df1     = DataFrame(x=1:n, y=bvarray, Wartość="największa")
    df2     = DataFrame(x=1:n, y=avarray, Wartość="średnia")
    df3     = DataFrame(x=1:n, y=wvarray, Wartość="najmniejsza")
    df      = vcat(df1, df2, df3)
    suffix  = Dates.format(now(), "yyyy-mm-dd_HH:MM:SS")

    myplot  = plot(df, x=:x, y=:y, color=:Wartość, Geom.point, Geom.line, Guide.xlabel("Liczba populacji"), Guide.ylabel("Wartość rozwiązania"), Coord.cartesian(xmin=0, xmax=xmax, ymin=0, ymax=ymax))

    draw(SVG("out/out_knapsack__c1_"* string(c1) *"_c2_"* string(c2) *"_c3_"* string(c3) *"__"* suffix *".svg", 1200px, 900px), myplot)
end