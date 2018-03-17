# Selekcja rankingowa. Jesli pewne rozwiazania sa znacznie lepsze od innych,
# to w populacji potomnej pojawi sie odpowiednio wiecej kopii tych osobnikow
function createranking(ratearray::Array{Int64,1})
  ratesum       = 0
  arrlength     = length(ratearray)
  rankarray     = Tuple{Int64,Int64}[]
  copiesintotal = 0

  for k = 1 : arrlength
    ratesum += ratearray[k]
  end

  # Jesli zadne z rozwiazan z obecnej generacji nie spelnia wymagan
  # problemu, to proces selekcji osobnikow jest pomijany
  if ratesum == 0
    for k = 1 : arrlength
      push!(rankarray, (1, k))
    end
  else
    for k = 1 : arrlength
      copiesnumber = Int64(floor(selectingprobability(ratearray[k], ratesum) * arrlength))
      copiesintotal += copiesnumber
      push!(rankarray, (copiesnumber, k))
    end

    sort!(rankarray, by = x -> x[1], rev = true)
    i = 1

    # Jezeli liczba kopii wybranych w rankingu rozwiazan jest mniejsza od 
    # rozmiaru populacji, to nalezy zwiekszych liczbe kopii najlepszych osobnikow
    while copiesintotal != arrlength
      rankarray[i] = (rankarray[i][1]+1, rankarray[i][2])
      copiesintotal += 1
      i += 1
    end
  end

  return rankarray
end