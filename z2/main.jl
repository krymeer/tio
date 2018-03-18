include("startup.jl")
include("modifications.jl")
include("roulette.jl")
include("knapsack.jl")
include("solutions.jl")
include("appendix.jl")
include("otherselections.jl")
include("output.jl")

# Funkcja startowa programu
function main()
  dataerr = false

  if length(ARGS) != 6
    println(STDERR, errormsg)
  else
    crossprob = 0.0
    mutprob   = 0.0

    try
      crossprob = parse(Float64, ARGS[2])
      mutprob = parse(Float64, ARGS[4])
    catch
      println(STDERR, errormsg)
      dataerr = true
    end

    crosstype = lowercase(ARGS[3])
    muttype   = lowercase(ARGS[5])
    seltype   = lowercase(ARGS[6])

    if (seltype != "sr" && seltype != "sk" && seltype != "st") || (muttype != "mi" && muttype != "mz") || (crosstype != "kj" && crosstype != "kr") || dataerr || crossprob < 0.0 || crossprob > 1.0 || mutprob < 0.0 || mutprob > 1.0
      println(STDERR, errormsg)
    else
      maxweight, itemarr, dataerr = readdata(ARGS[1])

      if !dataerr && length(itemarr) > 0 && maxweight > 0
        findsolution(maxweight, itemarr, crossprob, crosstype, mutprob, muttype, seltype)
      end
    end
  end
end

main()