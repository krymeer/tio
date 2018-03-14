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