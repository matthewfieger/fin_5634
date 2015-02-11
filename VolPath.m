


function VolPath (Variance,kappa,theta,VolOfVariance,T,NRandom)
%rng(0);
dT = T/NRandom;
TimePoints = NRandom +1;
path = zeros(1,TimePoints);

sigmaV = VolOfVariance * sqrt(Variance);

path(1) = Variance;
    for j =1:NRandom
        drift = (kappa * ( theta - path(j) ) - 0.5 * sigmaV^2 )* dT /path(j);
        risk = sigmaV * sqrt(dT) /sqrt(path(j)) ;
        path(j+1) = path(j) * exp(drift + risk*randn);
    end
path = path.^0.5;
plot(0:NRandom,path);

