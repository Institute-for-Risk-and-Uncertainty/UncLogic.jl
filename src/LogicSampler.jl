###
#
#       Part of the UncLogic.jl package, for pushing uncertainty through
#       logical statements
#
#       This file defines a function for generating
#
#       Institute for Risk and Uncertainty, University of Liverpool
#
#                           Authors: Ander Gray, Enrique Miralles
#                           Email: -----
#
###


using LinearAlgebra             #   Main Library

#=
function randomBool(x :: UncBool, y :: UncBool, N = 10^3)

    checkUncBool.([x,y]);

    u1 = rand(N,1); u2 = rand(N,1);
    LogicOut = [u1 .< x u2 .< y];
    return LogicOut
end
=#
function randomBool(x :: UncBool, N = 10^3)

    checkUncBool(x);
    u1 = rand(N,1);
    LogicOut = u1 .< x;
    return LogicOut
end

function randomBool(UncArray :: Array{<:UncBool}, N = 10^3)
    NumUnc = length(UncArray); LogicOut = falses(N,NumUnc);
    for i = 1:NumUnc
        LogicOut[:,i] = randomBool(UncArray[i],N);
    end
    return LogicOut
end

function corrBool(x :: UncBool, y :: UncBool, corr = 0, N = 10^3)

    checkUncBool.([x,y]); checkCor(corr);

    us = CholeskyGaussian(N, corr);
    LogicOut = [us[:,1] .< x us[:,2] .< y];
    return LogicOut
end

function corrBool2(x :: UncBool, y :: UncBool, corr = 0, N = 10^3)
    # https://stats.stackexchange.com/questions/284996/generating-correlated-binomial-random-variables

    p = x; q = y;
    a = (1-p)*(1-q) + corr*sqrt(p*q*(1-p)*(1-q));
    b = 1 -q -a;
    c = 1 -p -a;
    d = a + p + q -1;

    probs = [a,b,c,d]; cdf = cumsum(probs);
    

end

function CholeskyGaussian(N = 1, correlation = 0)

    Cov = ones(2,2); Cov[1,2] = Cov[2,1] = correlation;
    a = cholesky(Cov).L;
    z = transpose(rand(Normal(),N,2));
    x = a * z;
    u = transpose(cdf.(Normal(),x));

    return hcat(u[:,1],u[:,2])
end

function ComputeJoint(x :: BitArray; plot = true)

    Ndims = size(x,2); Nsamples = size(x,1);

    if Ndims != 2; throw(ArgumentError("ComputeJoint only works for 2 dimensions.")); end

    jointProbsMC = [(x[:,1] .== false) .& (x[:,2] .== false) (x[:,1] .== false) .& (x[:,2] .== true) (x[:,1] .== true) .& (x[:,2] .== false) (x[:,1] .== true) .& (x[:,2] .== true)];

    jointProbsMC = sum(jointProbsMC, dims =1)/Nsamples
    if plot
        println("                   |  0,0  |   0,1   |   1,0  |   1,1  |")
        println("MC        joint results = $jointProbsMC")
    end

    return jointProbsMC

end

