###
#
#       Part of the UncLogic.jl package, for pushing uncertainty through
#       logical statements
#
#       This file defines the uncertain AND, OR and NOT operations
#
#       Institute for Risk and Uncertainty, University of Liverpool
#
#                           Authors: Ander Gray, Enrique Miralles
#                           Email: -----
#
###


function and(x :: UncBool, y :: UncBool, corr = DefaultCorr)
    checkUncBool(x); checkUncBool(y); checkCor(corr);

    if (typeof(x) <: Bool) && (typeof(y) <: Bool)
        return x && y;
    end
    if (typeof(x) <: Int) && (typeof(y) <: Int)
        return Bool(x) && Bool(y);
    end

    if x == 0 || y == 0; return false; end
    if x == 1; return y; end
    if y == 1; return x; end

    a = BCopula(x,y,corr); checkUncBool(a);
    return a;

end


function andGau(x :: UncBool, y :: UncBool, corr  = DefaultCorr)

    checkUncBool(x); checkUncBool(y); checkCor(corr);;

    if (typeof(x) <: Bool) && (typeof(y) <: Bool)
        return x && y;
    end
    if (typeof(x) <: Int) && (typeof(y) <: Int)
        return Bool(x) && Bool(y);;
    end
    z = Copula(x,y,corr); checkUncBool(z,true);
    return z;
end

(&)(x::UncBool , y::UncBool) = and(x, y);


function or(x :: UncBool, y ::UncBool, corr = DefaultCorr)
    
    checkUncBool(x); checkUncBool(y); checkCor(corr);
    if (typeof(x) <: Bool) && (typeof(y) <: Bool)
        return x || y;
    end
    if (typeof(x) <: Int) && (typeof(y) <: Int)
        return Bool(x) || Bool(y);
    end
    z = ~and(~x,~y,corr); checkUncBool(z,true);     # You may need to reverse the correlation
    return z;
end

(|)(x::UncBool , y::UncBool) = or(x, y);

function nor(x :: UncBool, y ::UncBool, corr)

    checkUncBool(x); checkUncBool(y); checkCor(corr);
    
    if (typeof(x) <: Bool) && (typeof(y) <: Bool)
        return ~(x && y);
    end
    if (typeof(x) <: Int) && (typeof(y) <: Int)
        return ~(Bool(x) && Bool(y));
    end
     
    z = ~and(x,y,corr); checkUncBool(z,true);
    return z
end

xor(x,y)= and(~and(~x,~y), ~and(x,y))

function not(x :: UncBool)
    checkUncBool(x);
    Notx = 1 - x;
    checkUncBool(Notx);
    return Notx;
end

~(x :: UncBool) = not(x)
~(x :: Int64)   = not(x)

!(x :: UncBool) = not(x);
!(x :: Int64) = not(x);

function conditional(x :: UncBool, y :: UncBool, corr = DefaultCorr) #P(XY)

    checkUncBool(x); checkUncBool(y); checkCor(corr);
    if x == 0; return 0; end; if y == 0; return NaN; end;
    conditional = and(x,y,corr)/dual(y);

    if isDual(conditional); conditional = dual(conditional);end
    return conditional
end


function Joint(x :: UncBool, y ::UncBool, corr = 0; plot = false)
    checkUncBool(x); checkUncBool(y); checkCor(corr);
    
    if all.(isscalar([x,y,corr]));
        a = BooleanCopula(~x, ~y,corr)
        b = BooleanCopula(~x, y, -1* corr);
        c = BooleanCopula(x, ~y, -1 * corr);
        d = BooleanCopula(x, y ,corr)
    else
        a = and(~x, ~y,corr);
        b = and(~x, y, -1* corr)
        c = and(x, ~y, -1 * corr);
        d = and(x, y, corr);
    end

    if plot
        println("                          | 0,0 | 0,1 | 1,0 | 1,1 |")
        println("UncLogic  joint results = $probs")
    end

    return [a, b, c, d]
end

function JointAnd(x :: Real, y :: Real, corr :: Real)

end

#=
function Joint(x :: UncBool, y :: UncBool, corr = 0; plot = false)

    # Computes the joint distribution, given two marginals and a correlation
    # 

    p = x; q = y;
    #a = (1-p)*(1-q) + corr*sqrt(p*q*(1-p)*(1-q));
    a = (1-p)*(1-q) + corr*sqrt(p*q*(1-p)*(1-q));
    b = 1 -p -a;
    c = 1 -q -a;
    d = a + p + q -1;

    probs = [a b c d];
    SUM = sum(probs);
    if minimum(probs) < 0
        throw(ArgumentError("Provided correlation coefficient incopatable with marginals.\nGenerated joint has negative probabilities: $probs"));
    end
    if !(SUM ∈ interval(0.999999, 1.00000001))
        throw(ArgumentError("Provided correlation coefficient incopatable with marginals.\nGenerated joint do not sum to 1.\nProbabilities: $probs\nsum: $SUM."));
    end
    if plot
        println("                          | 0,0 | 0,1 | 1,0 | 1,1 |")
        println("UncLogic  joint results = $probs")
    end

    return probs
end
=#

function JointCopula(x :: UncBool, y :: UncBool, corr = 0; plot = false)

    a = left(Copula(~x,~y,   corr));
    b = left(Copula(~x, y,-1*corr));
    c = left(Copula(x, ~y,-1*corr));
    d = left(Copula(x,  y,   corr));

    probs = [a b c d];

    if minimum(probs) < 0
        throw(ArgumentError("Provided correlation coefficient incopatable with marginals.\nGenerated joint has negative probabilities: $probs"));
    end
    
    if plot
        println("                          | 0,0 | 0,1 | 1,0 | 1,1 |")
        println("UncLogic  joint results = $probs")
    end

    return probs
end


function JointFrank(x :: UncBool, y :: UncBool, corr = 0; plot = false)

    a = left(Frank(~x,~y,   corr));
    b = left(Frank(~x, y,-1*corr));
    c = left(Frank(x, ~y,-1*corr));
    d = left(Frank(x,  y,   corr));

    probs = [a b c d];

    if minimum(probs) < 0
        throw(ArgumentError("Provided correlation coefficient incopatable with marginals.\nGenerated joint has negative probabilities: $probs"));
    end
    
    if plot
        println("                          | 0,0 | 0,1 | 1,0 | 1,1 |")
        println("UncLogic  joint results = $probs")
    end

    return probs
end


function UncCorr(Joint :: Array{Float64})
    # Computes the correlation coefficient from a vector of joint probs

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

function getValidCorr(x :: UncBool, y :: UncBool)

    checkUncBool.([x, y]);
    denominator = sqrt(x*(1-x)*y*(1-y));
    lower_bound_correlation = (max(x+y-1,0)-x*y)/denominator
    upper_bound_correlation = (min(x,y)-x*y)/denominator

    return Interval(lower_bound_correlation,upper_bound_correlation)
end