###
#   
#       Part of the UncLogic.jl package, for pushing uncertainty through 
#       logical statements
#       
#       This file defines the dependence functions. Copulas are used 
#       for probabilistic booleans, and exclusion zones for intervals. 
#
#       Institute for Risk and Uncertainty, University of Liverpool
#
#                           Authors: Ander Gray, Enrique Miralles
#                           Email: -----
#
###

include("NormalDistribution.jl")

left( x :: Number) = x;
right(x :: Number) = x;

left( x :: AbstractInterval) = x.lo;
right(x :: AbstractInterval) = x.hi;

function Copula(x :: UncBool, y :: UncBool, corr)


    if corr == 0; return π(x,y); end
    if corr == 1; return M(x,y); end
    if corr == -1; return W(x,y); end
    if corr == interval(-1,1); return interval(left( W(x,y) ), right( M(x,y) ));end
    #if corr == interval(-1,1); return interval(W( left(x), left(y) ), M( right(x), right(y)) );end
    
    return interval(Gau(left(x),left(y),left(corr)), Gau(right(x),right(y),right(corr)))
    #return Frank(x,y,corr)
end

π(x :: UncBool, y :: UncBool ) = x*y;
M(x :: UncBool, y :: UncBool ) = min(x, y);
W(x :: UncBool, y :: UncBool ) = max(x+y-1,0);

function Gau(x:: Float64, y :: Float64, corr :: Float64) 

    checkCor(corr)
    if corr == 1;  return M(x,y);end
    if corr == -1; return W(x,y);end
    if corr == 0 ; return π(x,y);end

    return bivariate_cdf(quantile.(Normal(),x),quantile.(Normal(),y), corr)
end

function AndFrank(x:: UncBool, y :: UncBool, corr :: UncBool)

    LB = Frank(left(x),left(y),left(corr))
    UB = Frank(right(x),right(y),right(corr))

    return interval(LB,UB);
end

function Frank(x:: Float64, y :: Float64, corr :: Float64)

    checkCor(corr)
    s = tan( pi * (1 -corr)/4);
    if corr == 1;  return M(x,y);end
    if corr == -1; return W(x,y);end
    if corr == 0 ; return π(x,y);end

    return log(s, 1 + (s^x - 1) * (s^y - 1)/(s-1))
        
end

function Gau(x:: UncBool, y :: UncBool, corr :: UncBool) 

    checkUncBool.([x,y]); checkCor(corr)

    bounds = [-1.0,-1.0];
    Xs = [left(x), right(x)]; Ys = [left(y), right(y)];
    Cors = [left(corr), right(corr)];
    for i = 1:2
            if Cors[i] == 1;  bounds[i] = M(Xs[i],Ys[i]);
        elseif Cors[i] == -1; bounds[i] = W(Xs[i],Ys[i]);
        elseif Cors[i] == 0 ; bounds[i] = π(Xs[i],Ys[i]);
        else bounds[i] = bivariate_cdf(quantile.(Normal(),Xs[i]),quantile.(Normal(),Ys[i]), Cors[i]); end
    end
    z = interval(bounds[1], bounds[2]);
    checkUncBool(z,true);
    return z
end


function BooleanCopula(p :: Union{Bool,Int64,Float64}, q :: Union{Bool,Int64,Float64}, r :: Union{Int64,Float64})

    denominator = sqrt(p*(1-p)*q*(1-q));
    Lr = (max(p+q-1,0)-p*q)/denominator;
    Ur = (min(p,q)-p*q)/denominator

    if r < Lr; return max(p+q-1,0);end
    if r > Ur; return min(p,q);end

    d = p * q + r*sqrt(p*q*(1-p)*(1-q));
    return d
end

function BCopula(p :: UncBool, q :: UncBool, r :: UncBool)
    
    checkUncBool(p); checkUncBool(q); checkCor(r);

    allScalar = (isscalar(p) && isscalar(q) && isscalar(r))
    if allScalar; return BooleanCopula(right(p), right(q), right(r)); end

    intervalCase = ((isscalar(p) || isinterval(p)) && (isscalar(q) || isinterval(q)))
    if intervalCase return BCopInterval(p,q,r); end

    fuzzyCase = ~(ispbox(p) || ispbox(q))
    if fuzzyCase; return BCopFuzzy(p, q, r); end

    return BCopPbox(p,q,r)
end

function BCopInterval(p :: UncBool, q :: UncBool, r :: UncBool)
        lB = BooleanCopula(left(p),left(q), left(r));
        uB = BooleanCopula(right(p),right(q), right(r));
        return interval(lB, uB);
end

function BCopPbox(p :: Union{Int64, Float64,Interval}, q :: pbox, r :: Union{Int64, Float64, Interval})

    RhoLeft = left(r);
    ANDl(x,y) = BooleanCopula(x,y,RhoLeft);
    LeftPbox = conv(left(p),q,op=ANDl);

    RhoRight = right(r);
    ANDr(x,y) = BooleanCopula(x,y,RhoRight);
    RightPbox = conv(right(p),q,op=ANDr);

    return env(LeftPbox,RightPbox)

end

BCopPbox(p :: pbox, q :: Union{Int64, Float64,Interval}, r :: Union{Int64, Float64,Interval}) = BCopPbox(q, p, r)

function BCopPbox(p :: pbox, q :: pbox, r :: Union{Int64, Float64, Interval})

    RhoLeft = left(r);
    ANDl(x,y) = BooleanCopula(x,y,RhoLeft);
    LeftPbox = conv(p,q,op=ANDl);

    RhoRight = right(r);
    ANDr(x,y) = BooleanCopula(x,y,RhoRight);
    RightPbox = conv(p,q,op=ANDr);

    return env(LeftPbox,RightPbox)
end

BCopPbox(p :: pbox, q ::FuzzyNumber, r :: Union{Int64, Float64,Interval}) = BCopPbox(p, makepbox(q), r)
BCopPbox(p :: FuzzyNumber, q ::pbox, r :: Union{Int64, Float64,Interval}) = BCopPbox(makepbox(p),q, r)

function BCopFuzzy(p :: Union{Int64, Float64,Interval}, q :: FuzzyNumber, r :: Union{Int64, Float64, Interval})

    RhoLeft = left(r);
    ANDl(x,y) = BCopInterval(x,y,RhoLeft);
    LeftPbox = sigmaFuzzy(p,q,op=ANDl);

    RhoRight = right(r);
    ANDr(x,y) = BCopInterval(x,y,RhoRight);
    RightPbox = sigmaFuzzy(p,q,op=ANDr);

    return env(LeftPbox,RightPbox)
end

BCopFuzzy(p :: FuzzyNumber, q :: Union{Int64, Float64,Interval}, r :: Union{Int64, Float64, Interval}) = BCopFuzzy(q,p,r)

function BCopFuzzy(p :: FuzzyNumber, q :: FuzzyNumber, r :: Union{Int64, Float64, Interval})

    RhoLeft = left(r);
    ANDl(x,y) = BCopInterval(x,y,RhoLeft);
    LeftPbox = sigmaFuzzy(p,q,op=ANDl);

    RhoRight = right(r);
    ANDr(x,y) = BCopInterval(x,y,RhoRight);
    RightPbox = sigmaFuzzy(p,q,op=ANDr);

    return env(LeftPbox,RightPbox)
end


function andL(p :: FuzzyNumber, q :: FuzzyNumber, r :: Union{Int64, Float64, Interval})

    RhoLeft = left(r);
    ANDl(x,y) = BCopInterval(x,y,RhoLeft);
    LeftPbox = levelwise(p,q,op=ANDl);

    RhoRight = right(r);
    ANDr(x,y) = BCopInterval(x,y,RhoRight);
    RightPbox = levelwise(p,q,op=ANDr);

    return env(LeftPbox,RightPbox)
end


function andF(p :: FuzzyNumber, q :: FuzzyNumber, r :: Union{Int64, Float64, Interval})

    RhoLeft = left(r);
    ANDl(x,y) = BCopInterval(x,y,RhoLeft);
    LeftPbox = tauFuzzy(p,q,op=ANDl, C = W());

    RhoRight = right(r);
    ANDr(x,y) = BCopInterval(x,y,RhoRight);
    RightPbox = tauFuzzy(p,q,op=ANDr, C = W());

    return env(LeftPbox,RightPbox)
end
