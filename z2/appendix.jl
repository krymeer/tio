# Zamiana kolejnosci dwoch elementow
function swap(arr::Array, i::Int64, j::Int64)
  tmp = arr[i]
  arr[i] = arr[j]
  arr[j] = tmp
end

# Sprawdzenie czasu wykonywania algorytmu
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
function printpopulation(knapsacks::Array{String,1}, itemarr::Array{Item,1})
  println()

  for k = 1 : length(knapsacks)
    println(knapsacks[k], "\t",  getitems(knapsacks[k]), "\t", getvalue(knapsacks[k], itemarr), "\t", getweight(knapsacks[k], itemarr))
  end

  println()
end

# Negowanie wybranego bitu chromosomu
function negate(chromosome::String, k::Int64)
  newbit = ""

  if chromosome[k:k] == "1"
    newbit = "0"
  else
    newbit = "1"
  end

  return chromosome[1:k-1] * newbit * chromosome[k+1:length(chromosome)]
end