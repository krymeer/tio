# Prawdopodobienstwo wyboru danego rozwiazania ‒ stosunek oceny przystosowania danego rozwiazania do sumy wszystkich znanych unikalnych permutacji
function selectingprobability(rate::Float64, ratesum::Float64)
  return rate/ratesum * 100.0
end

# Wyznaczanie rangi poszczegolnych rozwiazan. Rozwiazanie o najmniejszym koszcie jest najlepiej oceniane
function countrates(routes::Array{Array{Int64,1},1}, towns::Array{Town,1}, costarr::Array{Float64,1})
  ratearr   = Float64[]
  ratesum   = 0

  # Maksymalizacja ‒ najmniejsza wartosc staje sie ta najwieksza
  for k = 1 : length(routes)
    push!(ratearr, 1/costarr[k])
    ratesum += ratearr[k]
  end

  return ratearr, ratesum
end

# Tworzenie kola ruletki
function makecirle(routes::Array{Array{Int64,1},1}, towns::Array{Town,1}, costarr::Array{Float64,1})
  ratearr, ratesum  = countrates(routes, towns, costarr)
  circle            = [(0.0, selectingprobability(ratearr[1], ratesum))]

  for k = 2 : length(routes)
    cpoint = circle[k-1][2]
    push!(circle, (cpoint, cpoint + selectingprobability(ratearr[k], ratesum)))
  end

  return circle
end