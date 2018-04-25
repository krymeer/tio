# Sprawdzenie czasu wykonywania algorytmu.
# Szukanie rozwiazania problemu trwa co najwyzej 20 min
function endoftime(starttime::Float64)
    timenow = time()
    timeint = round(timenow - starttime)

    if (timenow - starttime) > 1200
        return true
    end

    return false
end

# Drukowanie wszystkich rozwiazan z danej populacji. 
# Wyswietlane sa: uzyte przedmioty, ich wartosc oraz laczna waga plecaka
function printpopulation(knapsacks::Array{Array{Int64,1},1}, itemarr::Array{Item,1}, maxweight::Float64)
    println()

    for k = 1 : length(knapsacks)
        println(knapsacks[k], "\t",  getitems(knapsacks[k]), "\t", getvalue(knapsacks[k], itemarr, maxweight), "\t", getweight(knapsacks[k], itemarr))
    end

    println()
end

# Ustalenie rozmiaru populacji. Wedlug jednego ze zrodel:
# "Further increase of the population size, does not improve the solution accuracy"
function setpopulationsize(n::Int64)
    return 50 + Int64(floor(n / 10)) 
end