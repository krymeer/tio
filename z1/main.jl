include("towns.jl")
include("roulette.jl")
include("modifications.jl")
include("populations.jl")
include("appendix.jl")
include("solutions.jl")
include("startup.jl")

# Funkcja startowa programu
function main()
  dataerr = false

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
      dataerr = true
    end

    if dataerr || crossprob < 0.0 || crossprob > 1.0 || mutprob < 0.0 || mutprob > 1.0
      println(STDERR, errormsg)
    else
      townnum, towndata, dataerr = readdata(ARGS[1])

      if !dataerr && townnum < 3
        println(STDERR, "\nBłąd: zbyt mala liczba miast (", townnum, ")\n", errormsg)
        dataerr = true
      end

      if !dataerr && typeof(townnum) === Int64 && townnum > 0 && length(towndata) > 0
        findsolution(townnum, towndata, crossprob, mutprob)
      end
    end
  end
end

main()