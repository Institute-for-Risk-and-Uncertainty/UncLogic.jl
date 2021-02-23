and(a,b) = return a && b

not(a) = ~a

or(a,b) = ~and(~a,~b)

nand(a,b) = ~and(a,b)

nor(a,b) = ~or(a,b)

xor(a,b) = and(nand(a,b), or(a,b))

xor(a,b) = and(~and(a,b), ~and(~a,~b))

eq(a,b) = ~xor(a,b)

imp(a,b) = or(~a,b)

inh(a,b) = ~imp(a,b)


A = [true, true, false, false]

B = [true, false, true, false]


notA = not.(A)
notB = not.(B)
ands = and.(A,B)
ors = or.(A,B)
nands = nand.(A,B)
xors = xor.(A,B)
eqs = eq.(A,B)
impA = imp.(A,B)
impB = imp.(B,A)
inhA = inh.(A,B)
inhB = inh.(B,A)

println("~A      : $notA")
println("~B      : $notB")
println("A & B   : $ands")
println("A | B   : $ors")
println("A nand B: $nands")
println("A xor B : $xors")
println("A = B   : $eqs")
println("A imp B : $impA")
println("B imp A : $impB")
println("A inh B : $inhA")
println("B inh A : $inhB")
