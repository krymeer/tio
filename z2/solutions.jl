# Znajdowanie rozwiazania problemu komiwojazera
function findsolution(maxweight::Int64, itemarr::Array{Item,1}, crossprob::Float64, mutprob::Float64, selectiontype::String)
  starttime       = time()
  n               = length(itemarr)
  g               = 1
  gmax            = 100
  populationsize  = 2^(n-1)
  knapsacks       = initialise(n, populationsize)

  while true
    ratearray = computefitness(maxweight, knapsacks, itemarr)

    if g > gmax || endoftime(starttime)
      break
    end

    println("INITIAL POPULATION")
    printpopulation(knapsacks, itemarr)

    if selectiontype == "r"
      circle = makecirle(ratearray)
      knapsacks = newpopulation(knapsacks, circle)
    end

    println("\nNEW GENERATION")
    printpopulation(knapsacks, itemarr)

    if crossprob > 0
      randarr = shuffle(collect(1:populationsize))
      i       = 1
      imax    = ceil(populationsize/2)

      while i < imax
        childleft, childright = cross(knapsacks[randarr[i]], knapsacks[randarr[i+1]], crossprob)

        if childleft != "" && childright != ""
          knapsacks[randarr[i]]   = childleft
          knapsacks[randarr[i+1]] = childright
        end

        i += 2
      end
      println("\nAFTER CROSSING")
      printpopulation(knapsacks, itemarr)
    end

    if mutprob > 0
      for k = 1 : populationsize
        knapsacks[k] = mutate(knapsacks[k], mutprob)
      end
    end

    println("\nAFTER MUTATION")
    printpopulation(knapsacks, itemarr)

    #==== START OF TMP COND ====#
    
    if g == 1
      #break
    end

    #===== END OF TMP COND =====#

    g += 1
  end

  println()
end