# Znajdowanie rozwiazania problemu plecakowego
function findsolution(maxweight::Int64, itemarr::Array{Item,1}, c1::Float64, c2::Float64, c3::Float64)
    # Czas rozpoczecia działania funkcji 
    starttime           = time()

    # Liczba elementow w plecaku i rozmiar populacji
    n                   = length(itemarr)
    populationsize      = setpopulationsize(n)

    # Iterator i jego maksymalna wartosc
    g                   = 1
    gmax                = 2 * n^2

    # Pozycje i wartosci funkcji przystosowania czastek (chromosomow)
    p_arr, p_ratearr    = initialise(n, populationsize, itemarr, maxweight)
    
    # Najlepsze polozenia (poprzednicy) chromosomow z obecnej generacji
    pbest               = copy(p_arr)

    # Najlepsze znalezione rozwiazanie problemu plecakowego
    gbest, gbest_val    = getbest(maxweight, pbest, itemarr)

    # Wektory predkosci poszczegolnych czastek
    v_arr               = randomvelocities(n, populationsize)

    # Tablice do przechowywania wartosci wykorzystywanych przy tworzeniu wykresow
    bestvals_arr        = Int64[]
    worstvals_arr       = Int64[]
    meanvals_arr        = Float64[]
    
    while true        
        nozeros = filter(x -> x != 0, p_ratearr)
        push!(bestvals_arr, maximum(p_ratearr))

        if length(nozeros) > 0
            push!(worstvals_arr, minimum(nozeros))
            push!(meanvals_arr, mean(nozeros))
        else
            push!(worstvals_arr, 0)
            push!(meanvals_arr, 0)
        end

        v_arr        = updatevelocities(v_arr, p_arr, pbest, gbest, c1, c2, c3)
        p_arr        = updatepositions(v_arr)
        p_ratearr    = Int64[]

        for k = 1 : populationsize
            pval = getvalue(p_arr[k], itemarr, maxweight)
            push!(p_ratearr, pval)

            if pval >= getvalue(pbest[k], itemarr, maxweight)
                pbest[k] = p_arr[k]

                if pval >= gbest_val
                    gbest = pbest[k]
                    gbest_val = pval 
                end
            end
        end

        if g > gmax || endoftime(starttime)
            break
        end

        g += 1
    end

    println(STDERR, "\nNajlepsze rozwiazanie:\n", getitems(gbest), " (", gbest, ")")
    println(STDERR, "\nOcena najlepszego rozwiazania:\n", gbest_val)
    println(STDERR, "\nLiczba wygenerowanych populacji:\n", g, "\n")

    createchart(bestvals_arr, worstvals_arr, meanvals_arr, c1, c2, c3)
end