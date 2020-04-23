#E5 = R | K1
#E4 = E5 | S1
#E3 = E4 & S
#E2 = E3 | K2
#E1 = E2 | T

#with
include("../src/UncLogic.jl")

R = 10^-4
K1 = 3*10^-5
S1 = 3*10^-5
S = 10^-4
K2 = 3*10^-5
T = 5*10^-6

E5 = or(R,K1,1) #there is something I don't like: when the correlation exceeds the compatible one, the output is always both Frechet. shouldnt be only the one that is violated? (upper in this case)
#E5 = or(R,K1) #bug here
#E5_11 = and(R,K1) + and(R,~K1)
#E5_00 = and(~R,~K1)
#E5_10 = and(~R,K1)
#E5_01 = 0
#corE5 = UncCorr([E5_00 E5_10 E5_01 E5_11])

E4 = or(E5,S1,interval(-1,1))
E3 = and(E4,S,interval(-1,1))
E2 = or(E3,K2,interval(-1,1))
E1 = or(E2,T,interval(-1,1))

println(getValidCorr(R,K1))
#println(getValidCorr(left(E5),S1))
#println(getValidCorr(right(E5),S1))

#println(getValidCorr(E4,S))
#println(getValidCorr(E3,K2))
#println(getValidCorr(E2,T))
print(E5)
println(E1)



