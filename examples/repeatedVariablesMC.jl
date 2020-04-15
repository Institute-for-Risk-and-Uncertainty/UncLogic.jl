###
#
#       Part of the UncLogic.jl package, for pushing uncertainty through
#       logical statements
#
#       MC sampling for computing repeated variable correlation
#
#       Institute for Risk and Uncertainty, University of Liverpool
#
#                           Authors: Ander Gray, Enrique Miralles
#                           Email: -----
#
#           useful links: https://math.stackexchange.com/questions/610443/finding-a-correlation-between-bernoulli-variables\
#                         https://stats.stackexchange.com/questions/284996/generating-correlated-binomial-random-variables
#
###

include("../src/UncLogic.jl")

N = 10^4;

inputs = corrBool(0.5,0.9, 0.6, N);


out =  and.(inputs[:,1], inputs[:,2]);

inputOfInterest = inputs[:,1];
inputProb = sum(inputOfInterest)/N;

outProb = sum(out)/N;

#Joint = ComputeJoint(hcat(out, inputOfInterest));
Joint = ComputeJoint(inputs)

println()
println("------------")
println()

println("Input prob value  =  $inputProb")
println("Output prob value = $outProb")

InputMarginal = Joint[4] + Joint[2];
OutputMarginal = Joint[4] + Joint[3];

println()
println("------------")
println()
println("Input from joint   = $InputMarginal")
println("Output from joint  = $OutputMarginal")

VarInput = InputMarginal*(1 - InputMarginal);
VarOutput = OutputMarginal*(1 - OutputMarginal);


println()
println("------------")
println()
println("Input var   = $VarInput")
println("Output var  = $VarOutput")


CovInOut = Joint[4] - (Joint[4] + Joint[3]) * (Joint[4] + Joint[2])
StdIn = sqrt(VarInput);
StdOut = sqrt(VarOutput);
CorrInOut = CovInOut/(StdIn * StdOut)


println()
println("------------")
println()
println("Cov In/Out = $CovInOut")
println("Cor In/Out = $CorrInOut")

