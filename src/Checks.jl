###
#   
#       Part of the UncLogic.jl package, for pushing uncertainty through 
#       logical statements
#       
#       This file defines 
#
#       Institute for Risk and Uncertainty, University of Liverpool
#
#                           Authors: Ander Gray, Enrique Miralles
#                           Email: -----
#
###


function checkUncBool(x :: UncBool, Cal = false)
    
    msg = "Provided";
    if Cal; msg = "Calculated";end
    if typeof(x) <: Bool; return 1; end
    if typeof(x) <: Union{Int,Float64}; 
        if x > 1 || x < 0; 
            throw(ArgumentError("Probabilistic Boolean must be ∈ [0, 1]. $msg = $(x)"));
            return false;
        end; 
    end
    if typeof(x) <: AbstractInterval
        if x.hi > 1 || x.lo < 0; 
            throw(ArgumentError("Interval Boolean must be ⊆ [0, 1]. $msg = $(x)"));
            return false;
        end
    end
    return true;
end

function checkCor( x :: UncBool)

    Ok = true;
    if typeof(x) <: Bool; return Ok; end

    if typeof(x) <: Union{Int,Float64}; 
        if x > 1 || x < -1; Ok = false; end
    end

    if typeof(x) <: AbstractInterval
        if x.hi > 1 || x.lo < -1; Ok = false; end
    end

    if ~Ok; throw(ArgumentError("Correlation must be ⊆ [-1, 1]. Provided = $(x)"));end;
    return Ok;
end

function checkValidJoint(x:: UncBool, y:: UncBool, corr :: UncBool)

    # From Page 20. of Sandia report: Dependency modelling. Checking if provided corrletion
    # is within possible allowed bounds of marginal probabilities. Does not behave as expected.
    # Equations provided in sandia create correlation above 1.

    checkUncBool.([x, y]); checkCor(corr);
    denominator = sqrt(x*(1-x)*y*(1-y));
    lower_bound_correlation = (max(x+y-1,0)-x*y)/denominator
    upper_bound_correlation = (min(x,y)-x*y)/denominator

    println("r ∈ [$lower_bound_correlation, $upper_bound_correlation]")

    if corr < lower_bound_correlation || corr > upper_bound_correlation
        throw(ArgumentError("Correlation must be ⊆ [$(lower_bound_correlation), $(upper_bound_correlation)]. Provided = $(corr)"));
    end
    return true
end
