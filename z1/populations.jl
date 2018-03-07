# Rozmiar populacji rozwiazan problemu komiwojazera
# na podstawie: http://lipas.uwasa.fi/cs/publications/2NWGA/node11.html
function populationsizeold(n::Int64)
  if n < 5
    return div(factorial(n-1), 2)
  end

  return Int64(round(log(10, 1 - (0.99 ^ (1/n))) / log(10, (n-3) / (n-1))))
end

function populationsize(n::Int64)
  if n < 4
    return 1
  elseif n == 4 || n == 5
    return div(factorial(n-1), 2)
  else
    return n * 3
  end
end

# Sprawdzenie, czy dane rozwiazanie zostalo juz wybrane
function notchosen(chosenroute::Array{Int64,1}, routes::Array{Array{Int64,1},1})
  for i = 1 : length(routes)
    if routes[i] == chosenroute || routes[i] == reverse(chosenroute)
      return false
    end
  end

  return true
end

# Wybor rozwiazania, na ktore wskazuje wylosowana liczba (zgodnie z kolem ruletki)
function getsolutionindex(r::Float64, arr::Array{Tuple{Float64,Float64},1})
  for k = 1 : length(arr)
    if r >= arr[k][1] && r < arr[k][2] 
      return k
    end
  end

  println(STDERR, "\nUwaga: bledna wartosc prawdopodobienstwa wyboru rozwiazania (", r, ")")
  return 1
end

# Sprawdzenie, czy rozwiazanie spelnia zalozenia problemu komiwojazera
function goodroute(route::Array{Int64,1})
  for k = 2 : length(route)-1
    if findprev(route, route[k], k-1) > 0
      return false
    end
  end

  return true
end

# Inicjalizacja problemu ‒ tworzenie populacji poczatkowej. Pierwszym rozwiazaniem jest trasa [1, ..., n, 1], nastepnymi ‒ losowe, unikalne permutacje tego ciagu
function initialise(n::Int64, towndata::Array{Town,1}, kmax::Int64)
  k         = 1
  routes    = [vcat(collect(1:n), 1)]

  if kmax > 1
    while k < kmax
      while true
        rndperm = vcat(1, shuffle(copy(routes[1][2:n])), 1)

        if notchosen(rndperm, routes)
          push!(routes, rndperm)
          break
        end
      end

      k += 1
    end
  end

  return routes
end

# Tworzenie nowej populacji rozwiazan na podstawie danych wejsciowych oraz kola ruletki
function newpopulation(routes::Array{Array{Int64,1},1}, circle::Array{Tuple{Float64,Float64},1})
  newroutes = Array{Int64,1}[]

  for k = 1 : length(routes)
    random  = rand() * 100.0
    index   = getsolutionindex(random, circle)
    push!(newroutes, routes[index])
  end

  return newroutes
end