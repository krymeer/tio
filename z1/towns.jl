# Miasto na trasie komiwojazera
struct Town
  index::Int64
  x::Float64
  y::Float64
end

# Ocena populacji rozwiazan ‒ sumowanie kosztow odwiedzenia wszystkich miast
function getallcosts(routes::Array{Array{Int64,1},1}, towns::Array{Town,1})
  costarr         = Float64[]
  bestrouteindex  = 1

  for k = 1 : length(routes)
    c = getcost(routes[k], towns, false)
    push!(costarr, c)

    if k > 1 && c < costarr[bestrouteindex]
      bestrouteindex = k
    end
  end

  return costarr, bestrouteindex
end

# Wyznaczanie odleglosci miedzy dwoma miastami
function getdistance(a::Int64, b::Int64, towns::Array{Town,1})
  if a + b <= 2 * length(towns)
    return sqrt((towns[b].x-towns[a].x)^2 + (towns[b].y-towns[a].y)^2)
  end

  return 0.0
end

# Obliczenie kosztu przebycia danej trasy
function getcost(route::Array{Int64,1}, towns::Array{Town,1}, debug::Bool)
  cost = 0

  if debug
    println("\nKoszt przebycia trasy ", route, ":")
  end

  for k = 1 : length(towns)
    dist = getdistance(route[k], route[k+1], towns)
    cost += dist

    if debug
      println(route[k], " -> ", route[k+1], ":\t", dist)
    end
  end

  if debug
    println()
  end

  return cost
end