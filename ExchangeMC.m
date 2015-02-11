function [price, CI, Quality] = ExchangeMC(S1,S2,sigma1,sigma2,rho,r,T,NR)
% You could think of this as being a stochastic strike price.
randn('state',0);
Z1 = randn(1,NR);
Z2 = rho*Z1 + sqrt(1-rho^2)*randn(1,NR);
drift1 = (r - sigma1^2/2)*T;
risk1 = sigma1*sqrt(T);
drift2 = (r - sigma2^2/2)*T;
risk2 = sigma2*sqrt(T);
ST1 = S1*exp(drift1 + risk1*Z1);
ST2 = S2*exp(drift2 + risk2*Z2);
Intrinsic = max(0, ST1 - ST2);
[price, XX, CI] = normfit(exp(-r*T)*Intrinsic);
Quality = (CI(2)-CI(1))/price/2;