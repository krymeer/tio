# Znajdowanie rozwiazania problemu plecakowego
function findsolution(maxweight::Int64, itemarr::Array{Item,1}, crossprob::Float64, crosstype::String, mutprob::Float64, muttype::String, selectiontype::String)
  starttime       = time()
  n               = length(itemarr)
  populationsize  = setpopulationsize(n)
  g               = 1
  gmax            = 2 * n^2
  knapsacks       = initialise(n, populationsize)
  ratearray       = Int64[]
  bvarray         = Int64[]
  wvarray         = Int64[]
  avarray         = Float64[]
  
  while true
    ratearray = computefitness(maxweight, knapsacks, itemarr)
    nozeros   = filter(x -> x != 0, ratearray) 

    push!(bvarray, maximum(ratearray))

    if length(nozeros) > 0
      push!(wvarray, minimum(nozeros))
      push!(avarray, mean(nozeros))
    else
      push!(wvarray, 0)
      push!(avarray, 0)
    end

    if g > gmax || endoftime(starttime)
      break
    end

    if selectiontype == "sk"
      circle = makecirle(ratearray)
      knapsacks = newpopulation(knapsacks, circle)
    elseif selectiontype == "sr"
      rankarray = createranking(ratearray)
      knapsacks = newpopulation(knapsacks, rankarray)
    elseif selectiontype == "st"
      knapsacks = newtournamentpopulation(knapsacks, ratearray)
    end

    if crossprob > 0
      randarr = shuffle(collect(1:populationsize))
      i       = 1
      imax    = ceil(populationsize/2)

      while i < imax
        children = cross([knapsacks[randarr[i]], knapsacks[randarr[i+1]]], crosstype, crossprob)

        if children[1] != "" && children[2] != ""
          knapsacks[randarr[i]]   = children[1]
          knapsacks[randarr[i+1]] = children[2]
        end

        i += 2
      end
    end

    if mutprob > 0
      for k = 1 : populationsize
        if muttype == "mz"
          knapsacks[k] = mutate(knapsacks[k], mutprob)
        else
          knapsacks[k] = invert(knapsacks[k], mutprob)
        end
      end
    end

    g += 1
  end

  bvtuple       = findmax(ratearray)
  bvindex       = bvtuple[2]
  bestvalue     = bvtuple[1]
  bestknapsack  = knapsacks[bvindex]
  bestitems     = getitems(bestknapsack)

  createchart(bvarray, wvarray, avarray, crossprob, crosstype, mutprob, muttype, selectiontype)

  println(STDERR, "\nNajlepsze rozwiazanie:\n", getitems(bestknapsack), " (", bestknapsack, ")")
  println(STDERR, "\nOcena najlepszego rozwiazania:\n", bestvalue)
  println(STDERR, "\nLiczba wygenerowanych populacji:\n", g, "\n")
end