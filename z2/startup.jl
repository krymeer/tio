errormsg = "\nUzycie:\n\tz1.jl dw pk pm\n\nGdzie:\n\t- dw ‒ dane wejsciowe, tj. zbior przedmiotow i nosnosc plecaka,\n\t- pk ‒ prawdopodobienstwo krzyzowania [0, 1],\n\t- pm ‒ prawdopodobienstwo mutacji [0, 1].\n"

# Przetwarzanie danych zawartych w pliku
function readdata(filename::String)
  maxweight = 0
  itemarr   = Item[]
  dataerr   = false

  try
    f       = open(filename)
    lines   = readlines(f)

    try
      maxweight = parse(Int64, lines[1])
      shift!(lines)

      if maxweight <= 0
        println(STDERR, "\nBlad: dozwolona waga plecaka jest niedodatnia\n")
        dataerr = true
      else
        for l in lines
          e = split(replace(l, r"\s\s+", s" "), " ")
          w = parse(Int64, e[1])
          v = parse(Int64, e[2])

          push!(itemarr, Item(w, v))
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