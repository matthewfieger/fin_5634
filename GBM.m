function paths = GBM(S,r,q,sigma,T,N)
paths = zeros(1, N+1);
paths(1,1) = S;
dT = T/N;
drift = (r - q - sigma^2/2)* dT;
risk = sigma*sqrt(dT);
    for i=1:1:N
	paths(1,i+1) = paths(1,i)*exp(drift + risk*randn);
    end
plot(0:dT:T,paths(1,:));