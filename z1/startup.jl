errormsg = "\nUzycie:\n\tz1.jl dw pk pm\n\nGdzie:\n\t- dw ‒ dane wejsciowe, tj. zbior miast,\n\t- pk ‒ prawdopodobienstwo krzyzowania [0, 1],\n\t- pm ‒ prawdopodobienstwo mutacji [0, 1].\n"

# Przetwarzanie danych zawartych w pliku
function readdata(filename::String)
  townnum   = 0
  towndata  = Town[]
  dataerr = false

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
        dataerr = true
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

  return townnum, towndata, dataerr
end