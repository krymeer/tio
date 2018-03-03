# Zamiana kolejnosci dwoch elementow
function swap(arr::Array, i::Int64, j::Int64)
  tmp = arr[i]
  arr[i] = arr[j]
  arr[j] = tmp
end

# Wyswietlanie calej populacji rozwiazan
function printroutes(routes::Array{Array{Int64,1},1}, towns::Array{Town,1})
  for k = 1 : length(routes)
    println(routes[k], "\t", getcost(routes[k], towns, false))
  end
end

# Wyswietlanie najlepszej znalezionej trasy
function printbestlocalroute(routes::Array{Array{Int64,1},1}, towns::Array{Town,1})
  bestroute = routes[1] 
  bestcost  = getcost(routes[1], towns, false)

  for k = 2 : length(routes)
    cost = getcost(routes[k], towns, false)

    if cost < bestcost
      bestroute = routes[k]
      bestcost = cost
    end
  end

  println(bestroute, "\t", bestcost)
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