#E5 = R | K1
#E4 = E5 | S1
#E3 = E4 & S
#E2 = E3 | K2
#E1 = E2 | T

#with
include("../src/UncLogic.jl")

R = interval(10^-4, 10^-2)
K1 = 3*10^-5
S1 = 3*10^-5
S = interval(10^-4, 10^-3)
K2 = 3*10^-5
T = 5*10^-6

R5 = 0
R4 = interval(-1,1)
R3 = 0.15
R2 = 0
R1 = 1

@time begin
E5 = or(R,K1,R1) 
E4 = or(E5,S1,R2)
E3 = and(E4,S,R3)
E2 = or(E3,K2,R4)
E1 = or(E2,T,R5)
end
#println(getValidCorr(R,K1))
#println(getValidCorr(left(E5),S1))
#println(getValidCorr(right(E5),S1))

#println(getValidCorr(E4,S))
#println(getValidCorr(E3,K2))
#println(getValidCorr(E2,T))
println(E1)
#println(E1)



R = U(10^-4, 10^-2)
K1 = 3*10^-5
S1 = 3*10^-5
S = U(10^-4, 10^-3)
K2 = 3*10^-5
T = 5*10^-6

R5 = 0
R4 = interval(-1,1)
R3 = 0.15
R2 = 0
R1 = 1

@time begin
E5 = or(R,K1,R1) 
E4 = or(E5,S1,R2)
E3 = and(E4,S,R3)
E2 = or(E3,K2,R4)
E1 = or(E2,T,R5)
end
#println(getValidCorr(R,K1))
#println(getValidCorr(left(E5),S1))
#println(getValidCorr(right(E5),S1))

#println(getValidCorr(E4,S))
#println(getValidCorr(E3,K2))
#println(getValidCorr(E2,T))
plot(E1)
#println(E1)
