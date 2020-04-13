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

function CholeskyGaussian(N = 1, correlation = 0)

    Cov = ones(2,2); Cov[1,2] = Cov[2,1] = correlation;
    a = cholesky(Cov).L;
    z = transpose(rand(Normal(),N,2));
    x = a * z;
    u = transpose(cdf.(Normal(),x));

    return hcat(u[:,1],u[:,2])
end

