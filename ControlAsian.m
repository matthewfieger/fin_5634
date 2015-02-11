function [price, CI, Quality] = ControlASIAN (S,K,r,q,T,sigma,NPoints,NR1,NR2)
Underlying = GBMPaths(S,r,q,sigma,T,NPoints,NR1);
AVEPrice = mean(Underlying(:,2:NPoints+1) , 2);
Intrinsic = exp(-r*T)*max(0,AVEPrice - K);
SUMPrice = sum(Underlying, 2);
SampleCov = cov(SUMPrice,Intrinsic);
c = SampleCov(1,2)/var(SUMPrice);
dT=T/NPoints;
ExpectedSUM = S*(1-exp((r-q)*dT*(NPoints+1)))/(1-exp((r-q)*dT));
% First random discarded to avoid bias
Underlying = GBMPaths(S,r,q,sigma,T,NPoints,NR2);
AVEPrice = mean(Underlying(:,2:NPoints+1) , 2);
Intrinsic = exp(-r*T)*max(0,AVEPrice - K);
SUMPrice = sum(Underlying, 2);
ControlVar = Intrinsic - c*(SUMPrice - ExpectedSUM);
[price, XX, CI] = normfit(ControlVar);
Quality = (CI(2)-CI(1))/price/2;
