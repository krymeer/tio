# Znajdowanie rozwiazania problemu komiwojazera
function findsolution(n::Int64, towndata::Array{Town,1}, crossprob::Float64, mutprob::Float64)
  starttime = time()
  psize     = populationsize(n)
  g         = 1
  gmax      = 2*n
  routes    = initialise(n, towndata, psize)
  bestroute = Int64[]
  bestcost  = typemax(Int64)

  println("\nPopulacja poczatkowa:")
  printroutes(routes, towndata)

  while true
    costarr, bestcostindex  = getallcosts(routes, towndata)
    bestlocalcost           = costarr[bestcostindex]

    if bestlocalcost < bestcost
      bestcost  = costarr[bestcostindex]
      bestroute = routes[bestcostindex]
    end

    if psize == 1 || g > gmax || endoftime(starttime)
      break
    end

    circle = makecirle(routes, towndata, costarr)
    routes = newpopulation(routes, circle)

    # Losowa kolejnosc wyboru rodzicow do krzyzowania
    randarr = shuffle(collect(1:psize))
    i       = 1
    imax    = ceil(psize/2)

    while i < imax
      cross(routes[randarr[i]], routes[randarr[i+1]], crossprob)
      i += 2
    end

    for k = 1 : psize
      mutate(routes[i], mutprob)
    end

    g += 1
  end

  if psize > 1
    println("\nPopulacja koncowa:")
    printroutes(routes, towndata)
  end

  println("\nNajlepsze rozwiazanie z ostatniej populacji:")
  printbestlocalroute(routes, towndata)

  println("\nLiczba pokolen: ", g)

  if psize > 1
    println("\nNajlepsze rozwiazanie ogolem:")
    println(bestroute, "\t", bestcost, "\n")
  else
    println()
  end
end