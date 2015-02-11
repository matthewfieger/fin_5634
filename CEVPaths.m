

function CEVPaths (S,r,vol_0,beta,T,NRandom)
	% randn('state',0); % Specify the seed for random number generation.
	dT = T/NRandom; % Divide the path into intervals.
	path = zeros(1,NRandom+1);
	path(1,1) = S;

	sigma = vol_0*S^((2-beta)/2);
	var = sigma^2;
	SqrtdT = sqrt(dT);
	    for j =1:NRandom
	       drift = ( r - 0.5 * var *(path(j)^(beta-2)) )*dT;
	       risk = sigma *(path(j)^((beta-2)/2)) * SqrtdT ;
	       path(j+1) = path(j) * exp(drift + risk*randn);
	    end

	plot(0:NRandom,path);