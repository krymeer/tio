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
function cross(parents::Array{String,1}, crosstype::String, crossprob::Float64)
  children = ["", ""]

  if rand() < crossprob
    len         = length(parents[1])

    if crosstype == "kj"
      # Krzyzowanie jednopunktowe
      i           = rand(2:len-1)
      children[1] = parents[1][1:i-1] * parents[2][i:len]
      children[2] = parents[2][1:i-1] * parents[1][i:len]
    elseif crosstype == "kr"
      # Krzyzowanie rownomierne. Tworzenie kazdego potomka jest realizowane poprzez
      # losowy wybor takiej samej liczby genow (lub roznej o 1) od obydwu rodzicow
      for k = 1 : 2
        l       = 0
        ctr     = [0, 0]
        halflen = [floor(len/2), len-floor(len/2)]

        while l != len 
          r = rand(1:2)

          if ctr[r] < halflen[r]
            l += 1
            ctr[r] += 1
            children[k] *= parents[r][l:l]
          end
        end
      end
    end
  end

  return children
end