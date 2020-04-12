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
    

end

π(x :: UncBool, y :: UncBool ) = x*y;
M(x :: UncBool, y :: UncBool ) = min(x, y);
W(x :: UncBool, y :: UncBool ) = max(x+y-1,0);

function Gau(x:: UncBool, y :: UncBool, corr :: Float64) 

    checkCor(corr)
    if corr == 1;  return M(x,y);end
    if corr == -1; return W(x,y);end
    if corr == 0 ; return π(x,y);end
    
    return bivariate_cdf(quantile.(Normal(),x),quantile.(Normal(),y), corr)
end




