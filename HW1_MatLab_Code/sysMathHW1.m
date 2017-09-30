

clear
clc
syms n sigma y x beta1 beta2 beta3 beta4 beta5 X1 X2

lnL = 0.5*n*log(2*pi)+0.5*sum(beta4+beta5*X1)...
    +0.5*sum(((y-beta1-beta2*X1-beta3*X2)^2)/(exp(beta4+beta5*X1)));

test = jacobian(lnL, beta1)

f = n*X1^2

fdiff = diff(f, X1)
