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
    # https://stats.stackexchange.com/questions/284996/generating-correlated-binomial-random-variables
    # Pearson product-moment correlation coefficient
    
    checkUncBool.([x,y]);  checkCor(corr);
    
    probs = Joint(x,y,corr);

    items = [false false; false true; true false; true true]

    randCat = sample([1,2,3,4], Weights(probs[:]),N);
    LogicOut = items[randCat,:]

    return BitArray(LogicOut)
end


function corrBoolGau(x :: UncBool, y :: UncBool, corr = 0, N = 10^3)

    checkUncBool.([x,y]); checkCor(corr);
    us = CholeskyGaussian(N, corr);
    LogicOut = [us[:,1] .< x us[:,2] .< y];
    return LogicOut
end

function corrBoolConditional(x :: UncBool, y :: UncBool, corr = 0, N = 10^3)        # Conditional sampling

    trueCon = conditional(y,x,corr);                          # Probability of y, given x is true
    falseCon = conditional(y,~x,-1*corr);                     # Probability of y, given x is false

    trueCon = left(trueCon); falseCon = left(falseCon);

    firstVec = randomBool(x,N);                               # Bernoullis following prob x
    us = rand(N,1);                                           
    
    trueVec = firstVec;                                       # Vector of xs
    notTrueVec = .~ firstVec;                                 # Vector of not xs

    trueVec = trueVec .* trueCon;                             # Vector of P(y|x)
    notTrueVec = notTrueVec .* falseCon;                      # Vector of P(y|~x)

    mixedVec = trueVec .+ notTrueVec;                         # Conditional probability vector given first random result

    secondVec = us .< mixedVec;                               # Sampling conditional prob vector
    return [firstVec secondVec]
end

#function corrBoolScott(x :: UncBool, y :: UncBool, corr = 0 )
#    a = r * sqrt(p*q*(1-p)*(1-q)) + (1-p)*(1-q)
#bbd = c(`(0,0)`=a, `(1,0)`=1-q-a, `(0,1)`=1-p-a, `(1,1)`=a+p+q-1)
#if (min(bbd) < 0) stop(paste('Infeasible correlation ', paste(as.character(signif(bbd,3)),collapse=' ')))
# generate correlated binomial deviates
#n = 100
#u = sample.int(4, n, replace=TRUE, prob=bbd)
#y = floor((u-1)/2)
#x = 1 - u %% 2
#end

function CholeskyGaussian(N = 1, correlation = 0)

    Cov = ones(2,2); Cov[1,2] = Cov[2,1] = correlation;
    a = cholesky(Cov).L;
    z = transpose(rand(Normal(),N,2));
    x = a * z;
    u = transpose(cdf.(Normal(),x));

    return hcat(u[:,1],u[:,2])
end

function MCJoint(x :: BitArray; plot = true)

    Ndims = size(x,2); Nsamples = size(x,1);

    if Ndims != 2; throw(ArgumentError("ComputeJoint only works for 2 dimensions.")); end

    jointProbsMC = [(x[:,1] .== false) .& (x[:,2] .== false) (x[:,1] .== false) .& (x[:,2] .== true) (x[:,1] .== true) .& (x[:,2] .== false) (x[:,1] .== true) .& (x[:,2] .== true)];

    jointProbsMC = sum(jointProbsMC, dims =1)/Nsamples
    if plot
        println("                          | 0,0 | 0,1 | 1,0 | 1,1 |")
        println("MC        joint results = $jointProbsMC")
    end

    return jointProbsMC

end

