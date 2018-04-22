errormsg = "\nUzycie:\n\tmain.jl dw c1 c2 c3\n\nGdzie:\n\t- dw ‒ dane wejsciowe, tj. zbior przedmiotow i nosnosc plecaka,\n\t- c1 ‒ dowolna liczba z przedzialu (0, 1],\n\t- c2 ‒ dowolna liczba z przedzialu (0, 1],\n\t- c3 ‒ dowolna liczba z przedzialu (0, 1].\n"

# Przetwarzanie danych zawartych w pliku
function readdata(filename::String)
    maxweight   = 0
    itemarr     = Item[]
    dataerr     = false

    try
        f       = open(filename)
        lines   = readlines(f)

        try
            for l in lines
                e = split(replace(l, r"\s\s+", s" "), " ")

                if e[1] != "" && e[1][1:1] != "#"
                    if length(e) >= 2
                        w = parse(Int64, e[1])
                        v = parse(Int64, e[2])
                        push!(itemarr, Item(w, v))
                    else
                        maxweight = parse(Int64, e[1])

                        if maxweight <= 0
                            println(STDERR, "\nBlad: nosnosc plecaka powinna byc liczba dodatnia\n")
                            dataerr = true
                            break
                        end
                    end
                end
            end
        catch
            println(STDERR, "\nBlad: dane zawarte w pliku \"" * filename * "\" są nieprawidlowe\n")
            dataerr = true
        end

        close(f)
    catch
        println(STDERR, "\nPlik \"" * filename * "\" nie istnieje lub jest uszkodzony\n")
        dataerr = true
    end

    return maxweight, itemarr, dataerr
end