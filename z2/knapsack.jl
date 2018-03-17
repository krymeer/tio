# Potencjalny element plecaka
struct Item
  weight::Int64
  value::Int64
end

# Sprawdzenie, czy dane rozwiazanie problemu nie zostalo
# juz wybrane do populacji poczatkowej
function alreadychosen(str::String, arr::Array{String,1})
  for k = 1 : length(arr)
    if str == arr[k]
      return true
    end
  end

  return false
end

# Generowanie populacji poczatkowej.
# Chromosomy sa przedstawione w postaci "tekstowych" ciagow binarnych
function initialise(n::Int64, populationsize::Int64)
  population = String[]

  for i = 1 : populationsize
    while true
      chromosome = ""

      for j = 1 : n
        chromosome *= string(rand(0:1))
      end

      if !alreadychosen(chromosome, population)
        push!(population, chromosome)
        break
      end
    end
  end

  return population
end

# Generowanie populacji potomnej. Wybor osobnikow do reprodukcji jest zalezny od
# wylosowanej liczby i wycinka kola ruletki zajmowanego przez dane rozwiazanie
function newpopulation(knapsacks::Array{String,1}, circle::Array{Tuple{Float64,Float64},1})
  newknapsacks = String[]

  for k = 1 : length(knapsacks)
    random  = rand() * 100.0
    index   = getsolutionindex(random, circle)
    push!(newknapsacks, knapsacks[index])
  end

  return newknapsacks
end

# Generowanie populacji potomnej. Wybor osobnikow do reprodukcji jest zalezny od rankingu
# okreslajacego, ile kopii danego rozwiazania powinno pojawic sie w nowej populacji
function newpopulation(knapsacks::Array{String,1}, ranking::Array{Tuple{Int64,Int64},1})
  newknapsacks = String[]

  for i = 1 : length(knapsacks)
    for j = 1 : ranking[i][1]
      index = ranking[i][2]
      push!(newknapsacks, knapsacks[index])
    end
  end

  return newknapsacks
end

# Wyznaczanie wartosci funkcji dopasowania dla poszczegolnych rozwiazan problemu.
# Za najlepsze uwazane sa ciagi binarne reprezentujace ciagi przedmiotow o najwiekszej wartosci
# (i wadze nieprzekraczajacej maksymalna nosnosc plecaka)
function computefitness(maxweight::Int64, knapsacks::Array{String,1}, items::Array{Item,1})
  ratearr = Int64[]

  for i = 1 : length(knapsacks)
    v = 0
    w = 0

    for j = 1 : length(items)
      if knapsacks[i][j:j] == "1"
        v += items[j].value
        w += items[j].weight
      end
    end

    if w > maxweight
      v = 0
    end

    push!(ratearr, v)
  end

  return ratearr
end

# Ustalenie listy rzeczy znajdujacych sie w plecaku.
# Dla uproszczenia elementy sa ponumerowane od 1 do n
function getitems(knapsack::String)
  useditems = Int64[]
  
  for k = 1 : length(knapsack)
    if knapsack[k:k] == "1"
      push!(useditems, k)
    end
  end

  return useditems
end

# Wyznaczanie sumy wartosci przedmiotow umieszczonych w plecaku
function getvalue(knapsack::String, itemarr::Array{Item,1})
  v = 0

  for k = 1 : length(knapsack)
    if knapsack[k:k] == "1"
      v += itemarr[k].value
    end
  end

  return v
end

# Wyznaczanie lacznej wagi przedmiotow umieszczonych w plecaku
function getweight(knapsack::String, itemarr::Array{Item,1})
  v = 0

  for k = 1 : length(knapsack)
    if knapsack[k:k] == "1"
      v += itemarr[k].weight
    end
  end

  return v
end

