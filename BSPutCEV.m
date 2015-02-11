

function [price, CI, Quality] = BSPutCEV (S,K,r,q,T,sigma0,beta,NRandom,NSamples)
	rng(0); % Specify random number seed.
	dT = T/NRandom;
	sigma = sigma0*S^((2-beta)/2);
	Intrinsic = zeros(NSamples,1);

	for i = 1:NSamples
	    ST = S;
	    for j =1:NRandom
	       drift = ( r - q - 0.5 * (sigma^2) * (ST^(beta-2)) )*dT;
	       risk = sigma *(ST^((beta-2)/2)) * sqrt(dT) ;
	       STdT = ST * exp(drift + risk*randn);
	       ST = STdT;
	    end
	    Intrinsic(i) = max(0,K - ST);

	end
	[price, ~, CI] = normfit(exp(-r*T)*Intrinsic);
	Quality = (CI(2)-CI(1))/price/2;