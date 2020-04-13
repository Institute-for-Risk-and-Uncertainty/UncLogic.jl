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

