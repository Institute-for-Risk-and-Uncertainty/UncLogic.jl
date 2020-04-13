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


function and(x :: UncBool, y :: UncBool, corr  = DefaultCorr)

    checkUncBool.([x,y]); checkCor(corr);

    if (typeof(x) <: Bool) & (typeof(y) <: Bool)
        return x & y;
    end
    if (typeof(x) <: Int) & (typeof(y) <: Int)
        return x & y;
    end
    z = Copula(x,y,corr); checkUncBool(z,true);
    return z;
end


(&)(x::UncBool , y::UncBool) = and(x, y);

function or(x :: UncBool, y ::UncBool, corr = DefaultCorr)
    
    checkUncBool.([x,y]); checkCor(corr)
    if (typeof(x) <: Bool) & (typeof(y) <: Bool)
        return x | y;
    end
    if (typeof(x) <: Int) & (typeof(y) <: Int)
        return x | y;
    end
    z = ~and(~x,~y,corr); checkUncBool(z,true);     # You may need to reverse the correlation

    return z;
end

(|)(x::UncBool , y::UncBool) = or(x, y);

function not(x :: UncBool)
    checkUncBool(x);
    Notx = 1 - x;
    checkUncBool(Notx);
    return Notx;
end

~(x :: UncBool) = not(x)
~(x :: Int64)   = not(x)

function conditional(x :: UncBool, y :: UncBool, corr = DefaultCorr) #P(XY)

    checkUncBool.([x,y]); checkCor(corr);
    if x == 0; return 0; end; if y == 0; return NaN; end;
    conditional = and(x,y,corr)/y;

    return conditional
end