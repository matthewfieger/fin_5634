


function HestonPaths(S,r,q,VarOfPrice0,kappa,theta,VolOfVariance0,corr,T,NRandom)
	dT = T/NRandom;
	path = zeros(1,NRandom+1);
	path(1) = S;
	sigmaV = VolOfVariance0 * sqrt(VarOfPrice0);
	VT = VarOfPrice0;
		for j =1:NRandom
	        drift = ( r-q - 0.5 * VT )*dT;       
	        risk = sqrt(VT) * sqrt(dT);       
	        Z1 = randn;
	        path(j+1) = path(j) * exp(drift + risk*Z1);
			driftV =(kappa * ( theta - VT ) - 0.5 * sigmaV^2 )*dT / VT;
	        riskV = sigmaV * sqrt(dT) / sqrt(VT);
	        Z2 = corr*Z1 + sqrt(1 - corr^2)*randn;
	        VTdT = VT * exp(driftV + riskV*Z2);
	        VT = VTdT;
		 end

plot(0:NRandom,path);
end