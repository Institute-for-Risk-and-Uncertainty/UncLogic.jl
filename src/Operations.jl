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

    checkUncBool.([x,y]); checkCor(corr)

    z = Copula(x,y,corr); checkUncBool(z,true);

    return z;
end

(&)(x::UncBool , y::UncBool) = and(x, y);

function or(x :: UncBool, y ::UncBool, corr = DefaultCorr)
    
    checkUncBool.([x,y]); checkCor(corr)

    z = ~and(~x,~y,corr); checkUncBool(z,true); 

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