include("modifications.jl")
include("roulette.jl")
include("knapsack.jl")
include("solutions.jl")
include("appendix.jl")
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
      maxweight, itemarr, dataerr = readdata(ARGS[1])

      if !dataerr && length(itemarr) > 0
        findsolution(maxweight, itemarr, crossprob, mutprob, "r")
      end
    end
  end
end

main()