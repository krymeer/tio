#=

"W klasycznym algorytmie genetycznym cała poprzednia populacja chromosomów jest zastępowana przez tak samo liczną nową populację potomków"

=#

struct Town
  index::Int64
  x::Float64
  y::Float64
end

mutable struct Solution
  route::Array{Int64,1}
  cost::Float64
end

#=

Zasada działania:
1. DONE Wybór losowej populacji początkowej
2. DONE "Ocena przystosowania chromosomów", tzn. wybranie tych o najmniejszej wartości
3. Sprawdzenie warunku zatrzymania (czas, liczba populacji itp.)
4. DONE Selekcja chromosomów (te, które są „dobre”, zostają powielone i rozmnażają się)
5. Zapamiętywanie najlepszego rozwiązania

=#

# Wyznaczanie odleglosci miedzy dwoma miastami
function getdist(a::Int64, b::Int64, towns::Array{Town,1})
  len = length(towns)

  if a <= len && b <= len
    return ((towns[b].x-towns[a].x)^2 + (towns[b].y-towns[a].y)^2)
  end

  return 0
end

# Obliczenie kosztu przebycia danej trasy
function getcost(p::Array{Int64,1}, towndata::Array{Town,1})
  cost = 0

  for k = 1 : length(towndata)
    cost += getdist(p[k], p[k+1], towndata)
  end

  return cost
end

# Zamiana kolejnosci dwoch elementow
function swap(A::Array{Int64,1}, i::Int64, j::Int64)
  tmp = A[i]
  A[i] = A[j]
  A[j] = tmp
end

# Sprawdzenie, czy dane rozwiazanie zostalo juz wybrane
function checkperm(arr::Array{Int64,1}, solarr::Array{Solution,1})
  for i = 1 : length(solarr)
    if solarr[i].route == arr || solarr[i].route == reverse(arr)
      return true
    end
  end

  return false
end

# Tworzenie populacji poczatkowej. Pierwszym rozwiazaniem jest
# trasa [1, ..., n, 1], nastepnymi ‒ permutacje tego ciagu
function createpop(n::Int64, data::Array{Town,1}, kmax::Int64)
  perm    = vcat(collect(1:n), 1)
  poptln  = [Solution(perm, getcost(perm, data))]
  k       = 1

  while k < kmax && kmax > 1
    onthelist = true
    rndperm = Int64[]

    while onthelist
      rndperm   = vcat(1, shuffle(copy(perm[2:n])), 1)
      onthelist = checkperm(rndperm, poptln)
    end

    push!(poptln, Solution(rndperm, getcost(rndperm, data)))
    k += 1
  end

  return poptln
end

function countrates(population::Array{Solution,1}, maxrate::Float64)
  ratearr = Float64[]
  ratesum = 0

  for k = 1 : length(population)
    push!(ratearr, maxrate-population[k].cost)
    ratesum += ratearr[k]
  end

  return ratearr, ratesum
end

function selprob(solrate::Float64, ratesum::Float64)
  return Int64(round(solrate/ratesum * 100.0))
end

# Tworzenie kola ruletki
function makecirle(population::Array{Solution,1})
  psize             = length(population)
  ratearr, ratesum  = countrates(population, population[psize].cost)
  circle            = [(0, selprob(ratearr[1], ratesum))]

  for k = 2 : psize
    cpoint = circle[k-1][2]
    push!(circle, (cpoint, cpoint + selprob(ratearr[k], ratesum)))
  end

  return circle
end

function getsolutionindex(r::Int64, arr::Array{Tuple{Int64,Int64},1})
  for k = 1 : length(arr)
    if r >= arr[k][1] && r <= arr[k][2] 
      return k
    end
  end
end

function selectpop(population::Array{Solution,1}, circle::Array{Tuple{Int64,Int64},1})
  newpop = Solution[]

  for k = 1 : length(population)
    random  = rand(1:100)
    index   = getsolutionindex(random, circle)

    push!(newpop, Solution(copy(population[index].route), 0.0))
  end

  return newpop
end

function goodroute(route::Array{Int64,1})
  for k = 2 : length(route)
    if route[k] == route[k-1]
      return false
    end
  end

  return true
end

function mutate(route::Array{Int64,1}, mutprob::Float64)
  k     = 2
  kmax  = length(route)-1

  while k < kmax
    r = rand()

    if r <= mutprob
      i = rand(k:kmax)
      j = rand(k:kmax)
      swap(route, i, j)
    end

    k += 1
  end
end

function cross(r1::Array{Int64,1}, r2::Array{Int64,1}, crossprob::Float64)
  rnd = rand()
  m   = length(r1)-1
  ch1 = Int64[]
  ch2 = Int64[]

  if rnd <= crossprob
    i   = rand(2:m)
    ch1 = vcat(r1[1:i-1], r2[i:m+1])
    ch2 = vcat(r2[1:i-1], r1[i:m+1])

    if goodroute(ch1)
      println("good route ch1")
      r1 = ch1
    end

    if goodroute(ch2)
      println("good route ch2")
      r2 = ch2
    end
  end

end

function findsol(townnum::Int64, towndata::Array{Town,1}, crossprob::Float64, mutprob::Float64)
  psize       = binomial(townnum-1, 2)
  population  = createpop(townnum, towndata, psize)
  g           = 1
  gennum      = 30

  sort!(population, by=p->p.cost)
  circle  = makecirle(population)
  nextpop = selectpop(population, circle)

  for k = 1 : 2 : Int64(ceil(psize/2)) 
    cross(nextpop[k].route, nextpop[k+1].route, crossprob)
  end

  for k = 1 : psize
    mutate(nextpop[k].route, mutprob)
  end

  for k = 1 : psize
    nextpop[k].cost = getcost(nextpop[k].route, towndata)
  end

  # TODO
  # Pętla i opisy funkcji



  # PRINTING

  for k = 1 : length(population)
    println(population[k])
  end

  println("\n")
  for k = 1 : length(nextpop)
    println(nextpop[k])
  end

  #=
  while g < gennum
    g += 1
  end
  =#

end

# Przetwarzanie danych zawartych w pliku
function readdata(filename::String)
  townnum   = 0
  towndata  = Town[]
  exterr    = false

  try
    f       = open(filename)
    lines   = readlines(f)

    try
      townnum = parse(Int64, lines[1])
      shift!(lines)

      if townnum == length(lines)
        for l in lines
          e     = split(replace(l, r"\s\s+", s" "), " ")
          index = parse(Int64, e[1])
          townx = parse(Float64, e[2])
          towny = parse(Float64, e[3])

          push!(towndata, Town(index, townx, towny))
        end

        sort!(towndata, by=t->t.index)
      else
        println(STDERR, "\nBlad: zadeklarowana liczba informacji nie odpowiada faktycznej\n")
      end

    catch
      println(STDERR, "\nBlad: dane zawarte w pliku \"" * filename * "\" są nieprawidlowe\n")
      exterr = true
    end

    close(f)
  catch
    println(STDERR, "\nPlik \"" * filename * "\" nie istnieje lub jest uszkodzony\n")
  end

  return townnum, towndata, exterr
end

function main()
  errormsg = "\nUzycie:\n\tz1.jl dw pk pm\n\nGdzie:\n\t- dw ‒ dane wejsciowe, tj. zbior miast,\n\t- pk ‒ prawdopodobienstwo krzyzowania (0, 1],\n\t- pm ‒ prawdopodobienstwo mutacji (0, 1].\n"

  if length(ARGS) != 3
    println(STDERR, errormsg)
  else
    crossprob = 0.0
    mutprob   = 0.0

    try
      crossprob = parse(Float64, ARGS[2])
      mutprob = parse(Float64, ARGS[3])
    catch
      println(STDERR, errormsg)
    end

    if crossprob <= 0.0 || crossprob > 1.0 || mutprob <= 0.0 || mutprob > 1.0
      println(STDERR, errormsg)
    else
      townnum, towndata, exterr = readdata(ARGS[1])

      if typeof(townnum) === Int64 && townnum > 0 && length(towndata) > 0 && !exterr
        findsol(townnum, towndata, crossprob, mutprob)
      end
    end
  end
end

main()