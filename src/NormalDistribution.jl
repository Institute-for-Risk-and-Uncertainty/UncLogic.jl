######
# This file is part of the UncLogic.jl package.
#
#   Bivarte gaussian cdf function, by Gauss-Legendre quadrature
#
#           University of Liverpool, Institute for Risk and Uncertainty
#
#                                           Author: Liam T. Henry & Ander Gray
#                                           Email:  ander.gray@liverpool.ac.uk
#
#   Port of Fortran code By A. Genz (2013)
#   Original code at: http://www.math.wsu.edu/faculty/genz/homepage
#   Based on the paper: Numerical computation of rectangular bivariate
#                       and trivariate normal and t probabilities, A. Genz.
######


#Gauss Legendre points
abscissae6  = [-0.9324695142031522
               -0.6612093864662647
               -0.2386191860831970
               0.2386191860831970
               0.6612093864662647
               0.9324695142031522
               ]

weights6 = [0.1713244923791705
            0.3607615730481384
            0.4679139345726904
            0.4679139345726904
            0.3607615730481384
            0.1713244923791705
            ]

abscissae12 = [
-0.9815606342467191
-0.9041172563704750
-0.7699026741943050
-0.5873179542866171
-0.3678314989981802
-0.1252334085114692
0.1252334085114692
0.3678314989981802
0.5873179542866171
0.7699026741943050
0.9041172563704750
0.9815606342467191
]

weights12 = [
0.04717533638651177
0.1069393259953183
0.1600783285433464
0.2031674267230659
0.2334925365383547
0.2491470458134029
0.2491470458134029
0.2334925365383547
0.2031674267230659
0.1600783285433464
0.1069393259953183
0.04717533638651177
]


abscissae20 = [-0.9931285991850949,
               -0.9639719272779138,
               -0.9122344282513259,
               -0.8391169718222188,
               -0.7463319064601508,
               -0.6360536807265150,
               -0.5108670019508271,
               -0.3737060887154196,
               -0.2277858511416451,
               -0.07652652113349733,
               0.07652652113349733,
               0.2277858511416451,
               0.3737060887154196,
               0.5108670019508271,
               0.6360536807265150,
               0.7463319064601508,
               0.8391169718222188,
               0.9122344282513259,
               0.9639719272779138,
               0.9931285991850949,
               ]

weights20 = [0.01761400713915212,
             0.04060142980038694,
             0.06267204833410906,
             0.08327674157670475,
             0.1019301198172404,
             0.1181945319615184,
             0.1316886384491766,
             0.1420961093183821,
             0.1491729864726037,
             0.1527533871307259,
             0.1527533871307259,
             0.1491729864726037,
             0.1420961093183821,
             0.1316886384491766,
             0.1181945319615184,
             0.1019301198172404,
             0.08327674157670475,
             0.06267204833410906,
             0.04060142980038694,
             0.01761400713915212
             ]

abscissae = [abscissae6, abscissae12, abscissae20]
weights   = [weights6, weights12, weights20]
univariateData = [
  6.10143081923200417926465815756E-1,
 -4.34841272712577471828182820888E-1,
  1.76351193643605501125840298123E-1,
  -6.0710795609249414860051215825E-2,
  1.7712068995694114486147141191E-2,
 -4.321119385567293818599864968E-3,
  8.54216676887098678819832055E-4,
 -1.27155090609162742628893940E-4,
  1.1248167243671189468847072E-5,
  3.13063885421820972630152E-7,
 -2.70988068537762022009086E-7,
  3.0737622701407688440959E-8,
  2.515620384817622937314E-9,
 -1.028929921320319127590E-9,
  2.9944052119949939363E-11,
  2.6051789687266936290E-11,
 -2.634839924171969386E-12,
 -6.43404509890636443E-13,
  1.12457401801663447E-13,
  1.7281533389986098E-14,
 -4.264101694942375E-15,
 -5.45371977880191E-16,
  1.58697607761671E-16,
  2.0899837844334E-17,
 -5.900526869409E-18,
  -9.41893387554E-19,
  2.14977356470E-19,
  4.6660985008E-20,
 -7.243011862E-21,
 -2.387966824E-21,
  1.91177535E-22,
  1.20482568E-22,
 -6.72377E-25,
 -5.747997E-24,
 -4.28493E-25,
  2.44856E-25,
  4.3793E-26,
  -8.151E-27,
  -3.089E-27,
  9.3E-29,
  1.74E-28,
  1.6E-29,
  -8.0E-30,
  -2.0e-30
]
#CODY cdf?
function norm_cdf(x)
  P = 0
  A = univariateData
  RTWO = 1.414213562373095048801688724209
  IM = 25 #is this just truncated?

  XA = abs(x) / RTWO
  if XA > 100
    P = 0
  else
    T = (8*XA - 30) / (4*XA + 15)
    BM, BP, B = 0 , 0 , 0

    for I = IM:-1:1
      BP = B
      B  = BM
      BM = T*B - BP + A[I]
    end
    P = exp(-XA*XA)*(BM - BP)/4
  end
  if x>0
    P = 1-P
  end
  return P
end


function bivariate_cdf(a,b,p)

  if a == -Inf; return 0;end                # The following lines partially remove
  if b == -Inf; return 0;end                # NaNs calculated at extreme values
  if a ==  Inf && b ==  Inf; return 1;end

  if a == Inf; a = sqrt(prevfloat(Inf));end
  if b == Inf; b = sqrt(prevfloat(Inf));end

  if abs(p) < 0.3
   NG = 1
   LG = 3
   elseif abs(p) < 0.75
   NG = 2
   LG = 6
   else
   NG = 3
   LG = 10
  end
  H = -a
  K = -b
  HK = H*K
  BVN = 0

  if abs(p) < 0.925
    if abs(p) > 0
      HS = (H*H + K*K)/2
      ASR = asin(p)
      for I = 1:LG
        for IS in [-1,1]
          SN = sin(ASR * (IS * abscissae[NG][I] + 1 ) / 2 )
          BVN = BVN + weights[NG][I] * exp( (SN*HK - HS ) / (1 - SN*SN))
        end
      end
      BVN = BVN * ASR/(2 * 2pi)
    end
    BVN = BVN + norm_cdf(-H)*norm_cdf(-K)

  else
    if p < 0
      K = -K
      HK = -HK
    end
    if abs(p) < 1
      AS = (1 - p) * (1+p)
      A = sqrt(AS)
      BS = (H - K) * (H - K)
      C = (4 - HK) / 8
      D = (12 - HK) / 16
      ASR = -(BS/AS + HK)/2
      if ASR > -100
        BVN = A * exp(ASR) * (1 - C*(BS - AS)*(1 - D*BS/5)/3 + C*D*AS*AS/5)
      end
      if -HK < 100
        B = sqrt(BS)
        BVN = BVN - exp(-HK/2) * sqrt(2pi) * norm_cdf(-B/A) * B *(1-C*BS*(1 - D*BS/5)/3)
      end
      A = A/2
      for I = 1:LG
        for IS in [-1,1]
          XS = (A * (IS * abscissae[NG][I] + 1))^2
          RS = sqrt(1 - XS)
          ASR = - (BS/XS + HK)/2
          if ASR > -100
            BVN = BVN + A*weights[NG][I]*exp(ASR) * (exp(-HK*XS/(2*(1+RS)^2))/RS - (1 + C*XS*(1 + D*XS)))
          end
        end
      end
      BVN = -BVN/(2pi);
    end
    if p>0
      BVN = BVN + norm_cdf(-max(H,K))
    else
      BVN = -BVN
      if K>H
        if H<0
          BVN = BVN + norm_cdf(K) - norm_cdf(H)
        else
          BVN = BVN + norm_cdf(-H) - norm_cdf(-K)
        end
      end
    end
  end
  BVND = BVN
  return BVND
end
