
function paths = GBMPaths(S,r,q,sigma,T,N,NPaths)
	paths = zeros(NPaths, N+1);
	paths(:,1) = S;
	dT = T/N;
	drift = (r - q - sigma^2/2)* dT;
	risk = sigma*sqrt(dT);
	for j=1:NPaths
	    for i=1:1:N
		paths(j,i+1) = paths(j,i)*exp(drift + risk*randn);
	    end
	end

%	for j=1:NPaths
%		plot(0:dT:T,paths(j,:));
%		hold on;
%	end
%	hold off;