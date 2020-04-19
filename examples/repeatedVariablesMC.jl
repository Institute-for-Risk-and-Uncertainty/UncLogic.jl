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


function UncCorr(Joint :: Array{Float64})

    MarginalX = Joint[4] + Joint[2];
    MarginalY = Joint[4] + Joint[3];


    VarX= MarginalX*(1 - MarginalX);
    VarY = MarginalY*(1 - MarginalY);

    CovXY = Joint[4] - (Joint[4] + Joint[3]) * (Joint[4] + Joint[2])
    StdX = sqrt(VarX);
    StdY = sqrt(VarY);
    CorrXY = CovXY/(StdX * StdY)

    return CorrXY
end


N = 10^5;

p1 = 0.3; p2 = 0.9; corr = 0.9;

inputs = corrBool(p1,p2, corr, N);


out =  and.(inputs[:,1], inputs[:,2]);

inputOfInterest = inputs[:,1];
inputProb = sum(inputOfInterest)/N;

outProb = sum(out)/N;

Joint = ComputeJoint(hcat(out, inputOfInterest), plot =false);
#Joint = ComputeJoint(inputs,plot =false);

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
println("------------");
println()
println("Cov In/Out = $CovInOut")
println("Cor In/Out = $CorrInOut")

JointUncLogic = zeros(4,1)

JointUncLogic[4] = left(and(p1,p2,corr));
JointUncLogic[3] = 0 # Can never be 1 if either of the inputs are 0
JointUncLogic[2] = left(and(p1, ~p2,-1*corr));
JointUncLogic[1] = left(and(~p1,~p2,corr) + and(~p1,p2,-1*corr));



println()
println("------------")
println()
Joint = ComputeJoint(hcat(out, inputOfInterest));
println("UncLogic  joint         = $JointUncLogic")

McCor       = UncCorr(Joint)
UncLogicCor = UncCorr(JointUncLogic)
println()
println("------------")
println()
println("MC        cor           = $McCor")
println("UncLogic  cor           = $UncLogicCor")

