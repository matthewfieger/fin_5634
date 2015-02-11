
function [price CI Quality] = AsianMC (S,K,r,q,T,sigma,NR,NSamples, isCall)
% Arithmetic Average Call - Monte Carlo
% NR is the number of steps across a path and NSamples is the number of paths.
tic
randn('state',0);
Intrinsic = zeros(NSamples,1);
for i = 1:NSamples
    Underlying = GBMPaths(S,r,q,sigma,T,NR,1);
    AVEPrice = mean(Underlying(2:NR+1));
    if isCall
    	Intrinsic(i) = max(0,AVEPrice - K);
    else
    	Intrinsic(i) = max(0,K - AVEPrice);
    end
end
[price, XX, CI] = normfit(exp(-r*T)*Intrinsic);
Quality = (CI(2)-CI(1))/price/2;
toc