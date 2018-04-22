# Generowanie poczatkowych, losowych wektorow predkosci
function randomvelocities(n::Int64, populationsize::Int64)
    arr = Array{Float64,1}[]

    for i = 1 : populationsize
        v = Float64[]

        for j = 1 : n
            r = rand()

            if rand() < 0.5
                r *= -1
            end

            push!(v, r)
        end

        push!(arr, v)
    end

    return arr
end

# Normalizowanie wektora predkosci, tzn. zamiana kazdej
# jego wspolrzednej na liczbe z przedziału [0, 1]
# (po to, by mogl byc utozsamiany z prawdopodobienstwem)
function normalize(arr::Array{Float64,1})
    arr_n = Float64[]

    for k = 1 : length(arr)
        push!(arr_n, 1/(1 + e^(-arr[k])))
    end

    return arr_n
end

# Aktualizowanie wektorow predkosci zgodnie z danym wzorem. Zmienne:
# - r1, r2 ‒ losowo wybrane liczby
# - c1, c2, c3 ‒ parametry wejsciowe
function updatevelocities(varr::Array{Array{Float64,1},1}, parr::Array{Array{Int64,1},1}, pbest::Array{Array{Int64,1},1}, gbest::Array{Int64,1}, c1::Float64, c2::Float64, c3::Float64)
    varr_new = Array{Float64,1}[]

    for i = 1 : length(varr)
        r1  = rand()
        r2  = rand()
        v   = c1*varr[i] + c2*r1*(pbest[i] - parr[i]) + c3*r2*(gbest - parr[i])
        push!(varr_new, normalize(v))
    end

    return varr_new
end

# Aktualizowanie pozycji czasteczek wg zasady: jesli losowa
# liczba jest mniejsza od wartosci danej wspolrzednej wektora
# predkosci, to wspolrzedna pozycji ma wartosc 1; w p. p. - 0
function updatepositions(varr::Array{Array{Float64,1},1})
    parr_new    = Array{Int64,1}[]
    vlength     = length(varr[1])

    for i = 1 : length(varr)
        newpos = Int64[]

        for j = 1 : vlength
            b = 0

            if rand() < varr[i][j]
                b = 1
            end

            push!(newpos, b)
        end

        push!(parr_new, newpos)
    end

    return parr_new
end