# Potencjalny element plecaka
struct Item
    weight::Int64
    value::Int64
end

# Sprawdzenie, czy dane rozwiazanie problemu nie zostalo
# juz wybrane do populacji poczatkowej
function alreadychosen(bitarr::Array{Int64,1}, arr::Array{Array{Int64,1}})
    for k = 1 : length(arr)
        if bitarr == arr[k]
            return true
        end
    end

    return false
end

# Generowanie populacji poczatkowej.
# Chromosomy sa przedstawione w postaci "tekstowych" ciagow binarnych
function initialise(n::Int64, populationsize::Int64, items::Array{Item,1}, maxweight::Int64)
    population  = Array{Int64,1}[]
    ratearray   = Int64[]

    for i = 1 : populationsize
        while true
            chromosome = Int64[]

            for j = 1 : n
                push!(chromosome, rand(0:1))
            end

            if !alreadychosen(chromosome, population)
                push!(population, chromosome)
                push!(ratearray, getvalue(chromosome, items, maxweight))
                break
            end
        end
    end

    return population, ratearray
end

# Znajdowanie najlepszego rozwiazania z danej populacji
function getbest(maxweight::Int64, knapsacks::Array{Array{Int64,1},1}, items::Array{Item,1})
    bestknapsack  = Int64[]
    bestvalue     = 0

    for i = 1 : length(knapsacks)
        v = 0
        w = 0

        for j = 1 : length(items)
            if knapsacks[i][j] == 1
                v += items[j].value
                w += items[j].weight
            end
        end

        if w > maxweight
            v = 0
        end

        if v >= bestvalue
            bestknapsack = knapsacks[i]
            bestvalue = v
        end
    end

    return bestknapsack, bestvalue
end

# Obliczanie wartosci przedmiotow znajdujacych sie w plecaku. Jezeli plecak jest zbyt
# ciezki (jego waga przekracza maksymalna nosnosc), to przyjmuje sie, ze jego calkowita
# wartosc jest rowna zeru (ze wzgledu na to, ze nie jest rozwiazaniem problemu)
function getvalue(knapsack::Array{Int64,1}, items::Array{Item,1}, maxweight::Int64)
    knapval     = 0
    knapweight  = 0  

    for i = 1 : length(knapsack)
        if knapsack[i] == 1
            knapval += items[i].value
            knapweight += items[i].weight
        end
    end

    if knapweight > maxweight
        knapval = 0
    end

    return knapval
end

# Ustalenie listy rzeczy znajdujacych sie w plecaku
function getitems(knapsack::Array{Int64,1})
    useditems = Int64[]

    for k = 1 : length(knapsack)
        if knapsack[k] == 1
            push!(useditems, k)
        end
    end

    return useditems
end

# Obliczenie lacznej wagi przedmiotow znajdujacych sie w plecaku
function getweight(knapsack::Array{Int64,1}, items::Array{Item,1})
    w = 0

    for k = 1 : length(knapsack)
        if knapsack[k] == 1
            w += items[k].weight
        end
    end

    return w
end