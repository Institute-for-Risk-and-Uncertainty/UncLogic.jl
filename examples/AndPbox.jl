###
#   
#       Part of the UncLogic.jl package, for pushing uncertainty through 
#       logical statements
#    
#       Working with pboxes. Requires ProbabilityBoundsAnalysis.jl
#
#       Institute for Risk and Uncertainty, University of Liverpool
#
#                           Authors: Ander Gray, Enrique Miralles
#                           Email: -----
#
###


include("../src/UncLogic.jl")
#include("../../ProbabilityBoundsAnalysis.jl/src/ProbabilityBoundsAnalysis.jl")
#using Main.ProbabilityBoundsAnalysis


function and(x :: pbox, y ::pbox, r=0)
    
    RhoLeft = left(r);
    ANDl(x,y) = BooleanCopula(x,y,RhoLeft);
    LeftPbox = conv(x,y,ANDl);

    RhoRight = right(r);
    ANDr(x,y) = BooleanCopula(x,y,RhoRight);
    RightPbox = conv(x,y,ANDr);

    return env(LeftPbox,RightPbox)

end

#and(x::pbox, y :: Real, r) = env(and(x,left(y),r), and(x,right(y),r))
#and(x :: Real , y ::pbox, r) = and(y,x,r)


#a = beta(1,1);
#b = beta(interval(2,5),interval(0.1,1));
a = KN(5,6);
b = KN(5,6);


rho = interval(0.9,1);

c = and(a,b,rho)

plot(a)
plot(b)

#plot(c)

cols = ["red", "blue", "green", "orange", "purple", "yellow"];

cs = and.(a,b,range(-1,stop=1,length=6))

[plot(cs[i],name = "same", col = cols[i], alpha = 0.1) for i in 1:6]
#[plot(cs[i],name = "same", col = "red", alpha = 0.1) for i in 1:6]