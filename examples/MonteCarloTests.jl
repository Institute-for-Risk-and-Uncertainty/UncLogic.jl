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

probs = [0.3,0.4,0.5,0.6,0.7];
N = 10^7;
Indep = randomBool(probs, N);

results = sum(Indep, dims = 1)/N;

println("Probabilities = $probs");
println("Mc results    = $results");

println("--------------------------------------------------------------")

Probs2 = [0.9,0.2];
corr = 0.001 
corrBools = corrBool(Probs2[1],Probs2[2], corr, N);
results2 = sum(corrBools, dims=1)/N;

println("Probabilities = $Probs2");
println("Mc results    = $results2");

println()
jointProbs = [Gau(~Probs2[1], ~Probs2[2], corr), Gau(~Probs2[1], Probs2[2], -1*corr), Gau(Probs2[1], ~Probs2[2], -1*corr), Gau(Probs2[1], Probs2[2], corr)]
jointProbsMC = [(corrBools[:,1] .== false) .& (corrBools[:,2] .== false) (corrBools[:,1] .== false) .& (corrBools[:,2] .== true) (corrBools[:,1] .== true) .& (corrBools[:,2] .== false) (corrBools[:,1] .== true) .& (corrBools[:,2] .== true)];

jointMcResults = sum(jointProbsMC, dims = 1)/N;

println("                   |  0,0  |   0,1   |   1,0  |   1,1  |")
println("Real joint results = $jointProbs")
println("MC   joint results = $jointMcResults")

println()

println("Sum of Reals = $(sum(jointProbs))")
println("Sum of MC    = $(sum(jointMcResults))")
#test
