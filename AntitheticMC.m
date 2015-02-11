function [CallMC, CI, Quality] = AntitheticMC (S,K,r,T,sigma,q,NR)
randn('state',0);
drift = (r - q - sigma^2/2)*T;
risk = sigma*sqrt(T);
Samples = randn(NR,1);
ST1 = S*exp(drift + risk*Samples);
ST2 = S*exp(drift + risk*(-Samples));
Intrinsic = 0.5*(max(0,ST1 - K) + max(0,ST2 - K));
[CallMC, XX, CI] = normfit(exp(-r*T)*Intrinsic);
Quality = (CI(2)-CI(1))/CallMC/2;