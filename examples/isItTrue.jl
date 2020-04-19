###
#   
#       Part of the UncLogic.jl package, for pushing uncertainty through 
#       logical statements
#    
#       Example of a simple boolean function with uncertainty
#
#       Institute for Risk and Uncertainty, University of Liverpool
#
#                           Authors: Ander Gray, Enrique Miralles
#                           Email: -----
#
###


include("../src/UncLogic.jl")

#global DefaultCorr = interval(-1,1)

# Assume all inputs to be independent
function isItTrue(x :: UncBool, y :: UncBool, z :: UncBool)

    checkUncBool.([x,y,z]);

    depBefore = DefaultCorr;
    global DefaultCorr = 0;

    x1 = x & y;
    x2 = z | y;
    x3 = ~(x1 & x2);
    x4 = z | x2;
    x5 = x3 & ~y;
    x6 = x4 | ~y;

    global DefaultCorr = depBefore;

    checkUncBool.([x4,x5])
    return [x5, x6]

end

#isItTrue(x) = isItTrue(x[1], x[2], x[3])
#=
## With just booleans
x = 1; y = 0; z = 1;
println(isItTrue(x,y,z))

## With probabilities
x = 1; y = 0.5; z = 1;
println(isItTrue(x,y,z))

## With intervals
x = 1; y = interval(0.4,0.6); z = 1;
print(isItTrue(x,y,z))

#test
x=0.6; y=0.2;
print(conditional(x,y))
=#

InputProbs = [0.5,0.6,0.1];
N = 10^7;
randomBools = randomBool(InputProbs, N);

MCoutput = falses(N,2);

for i=1:N
    MCoutput[i,:] = isItTrue.(randomBools[i,1], randomBools[i,2], randomBools[i,3]);
end

McProbsOut = sum(MCoutput, dims=1)/N;

jointProbsMC = [(MCoutput[:,1] .== false) .& (MCoutput[:,2] .== false) (MCoutput[:,1] .== false) .& (MCoutput[:,2] .== true) (MCoutput[:,1] .== true) .& (MCoutput[:,2] .== false) (MCoutput[:,1] .== true) .& (MCoutput[:,2] .== true)];
jointMcResults = sum(jointProbsMC, dims = 1)/N;

println("                   |  0,0  |   0,1   |   1,0  |   1,1  |")
println("Mc joint results = $jointMcResults")

UncProbsOut = isItTrue(InputProbs[1], InputProbs[2], InputProbs[3])

println("MC results       = $McProbsOut")
println("UncLogic results = $UncProbsOut")