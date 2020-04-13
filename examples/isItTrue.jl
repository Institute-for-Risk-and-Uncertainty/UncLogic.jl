###
#   
#       Part of the UncLogic.jl package, for pushing uncertainty through 
#       logical statements
#    
#       Example of a simple boolean function with uncertainty
#
#       Institute for Risk and Uncertainty, University of Liverpool
#
#                           Authors: Ander Gray, Enrique Miralles
#                           Email: -----
#
###


include("../src/UncLogic.jl")


# Assume all inputs to be independent
function isItTrue(x :: UncBool, y :: UncBool, z :: UncBool)

    checkUncBool.([x,y,z]);

    depBefore = DefaultCorr;
    global DefaultCorr = 0;

    x1 = x & y; x2 = z | y;
    x3 = ~(x1 & x2);
    x4 = z | x2;
    x5 = x3 & ~y;

    global DefaultCorr = depBefore;

    checkUncBool.([x4,x5])
    return x4, x5;

end

## With just booleans
x = 1; y = 0; z = 1;
println(isItTrue(x,y,z))

## With probabilities
x = 1; y = 0.5; z = 1;
println(isItTrue(x,y,z))

## With intervals
x = 1; y = interval(0.4,0.6); z = 1;
print(isItTrue(x,y,z))

#test
x=0.6; y=0.2;
print(conditional(x,y))