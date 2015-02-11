function [CallMC, CI, Quality] = QualityMC(S,K,r,T,sigma,q,NR)
randn('state',0);
drift = (r - q - sigma^2/2)*T;
risk = sigma*sqrt(T);
ST = S*exp(drift + risk*randn(NR,1));
Intrinsic = max(0, ST - K);
[CallMC, XX, CI] = normfit(exp(-r*T)*Intrinsic);
Quality = (CI(2)-CI(1))/CallMC/2;

