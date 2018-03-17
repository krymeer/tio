# Prawdopodobienstwo wyboru danego rozwiazania, tj. stosunek oceny
# przystosowania danego rozwiazania do sumy ocen wszystkich osobnikow populacji
function selectingprobability(rate::Int64, ratesum::Int64, aspercentage::Bool=false)
  quotient = rate/ratesum

  if aspercentage
    quotient *= 100.0
  end

  return quotient
end

# Wybor rozwiazania, na ktore wskazuje wylosowana liczba (zgodnie ze zdefiniowanym kolem ruletki)
function getsolutionindex(r::Float64, circle::Array{Tuple{Float64,Float64},1})
  for k = 1 : length(circle)
    if r >= circle[k][1] && r < circle[k][2]
      return k
    end
  end
  println(STDERR, "\nUwaga: bledna wartosc prawdopodobienstwa wyboru rozwiazania (", r, ")")
  return 1
end

# Tworzenie kola ruletki. Kazde rozwiazanie problemu
# zajmuje "obszar" proporcjonalny do oceny przystosowania
function makecirle(ratearray::Array{Int64,1})
  ratesum   = 0
  arrlength = length(ratearray)
  frac      = 100 / arrlength

  for k = 1 : arrlength
    ratesum += ratearray[k]
  end

  circle  = Tuple{Float64,Float64}[]
  x       = 0.0

  for k = 1 : arrlength
    y = x

    if ratesum > 0
      y += selectingprobability(ratearray[k], ratesum, true)  
    else
      y += frac
    end

    push!(circle, (x, y))
    x = y
  end

  return circle
end