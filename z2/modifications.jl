# Mutacja rozwiazania: jesli wylosowana liczba jest mniejsza 
# od ustalonego prawdopodobienstwa, to wartosc danego bitu 
# jest zmieniana na przeciwna (0 => 1 lub 1 => 0)
function mutate(chromosome::String, mutprob::Float64)
  newchromosome = ""

  for k = 1 : length(chromosome)
    newchromosome *= chromosome[k:k]

    if rand() < mutprob
      newchromosome = negate(newchromosome, k)
    end
  end

  return newchromosome
end

# Mutacja rozwiazania na zasadzie inwersji: losowane sa dwie
# liczby naturalne a, b (a < b) bedace poczatkiem i koncem
# pewnego podciagu w tablicy (wektorze), ktory zostaje odwrocony
function invert(chromosome::String, mutprob::Float64)
  if rand() < mutprob
    n = length(chromosome)
    a = 0
    b = 0

    while a >= b
      a = rand(1:n)
      b = rand(1:n)
    end

    return (chromosome[1:a-1] * chromosome[a:b] * chromosome[b+1:n])
  else
    return chromosome
  end
end

# Krzyzowanie dwoch rozwiazan.
# Wybierany jest losowy punkt, wzgledem ktorego nastepuje wymiana "genow"
function cross(parentleft::String, parentright::String, crossprob::Float64)
  childleft   = ""
  childright  = ""

  if rand() < crossprob
    len         = length(parentleft)
    i           = rand(2:len-1)
    childleft   = parentleft[1:i-1] * parentright[i:len]
    childright  = parentright[1:i-1] * parentleft[i:len]
  end

  return childleft, childright
end