# Mutacja rozwiazania ‒ zamienienia kolejnosci sasiadujacych ze soba indeksow miast
function mutate(route::Array{Int64,1}, mutprob::Float64)
  if mutprob > 0
    k     = 2
    kmax  = length(route)-1

    while k < kmax
      if rand() < mutprob
        swap(route, k, k+1)
      end

      k += 1
    end
  end
end

# Krzyzowanie dwoch rozwiazan. Nowe wersje sa akceptowane wylacznie wtedy, gdy sa poprawnymi cyklami Hamiltona
function cross(parentleft::Array{Int64,1}, parentright::Array{Int64,1}, crossprob::Float64)
  rnd         = rand()
  parlen      = length(parentleft)
  childleft   = Int64[]
  childright  = Int64[]

  if rnd < crossprob && crossprob > 0
    i           = rand(2:parlen-1)
    childleft   = vcat(parentleft[1:i-1], parentright[i:parlen])
    childright  = vcat(parentright[1:i-1], parentleft[i:parlen])

    if goodroute(childleft)
      parentleft = childleft
    end

    if goodroute(childright)
      parentright = childright
    end
  end
end