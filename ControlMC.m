function [CallCVMC, CI, Quality] = ControlMC (S,K,r,T,sigma,q,NR1,NR2)
% Stock Price as a natural control variate
randn('state',0);
drift = (r - q - sigma^2/2)*T;
risk = sigma*sqrt(T);
ST = S*exp(drift + risk*randn(NR1,1));
ExpectedST = S*exp((r-q)*T);
VarST = (S^2)*exp(2*(r-q)*T)*(exp((sigma^2)*T) - 1);
Intrinsic = exp(-r*T)*max(0, ST - K);
SampleCov = cov(ST,Intrinsic);
c = SampleCov(1,2)/VarST;
% First random discarded to avoid bias
ST = S*exp(drift + risk*randn(NR2,1));
Intrinsic = exp(-r*T)*max(0, ST - K);
ControlVar = Intrinsic - c*(ST - ExpectedST);
[CallCVMC, XX, CI] = normfit(ControlVar);
Quality = (CI(2)-CI(1))/CallCVMC;
