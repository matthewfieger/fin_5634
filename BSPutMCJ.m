function price = BSPutMCJ(S,K,r,T,volStock,q,alphaJ,volJump,lambdaJ,NR)
alphaK = r - q - lambdaJ*(exp(alphaJ) - 1);
driftK = (alphaK - 0.5*volStock^2)*T;
risk = volStock*sqrt(T);
ST = S*exp(driftK + risk*randn(NR,1));
lambda = lambdaJ*T;
    for i = 1:NR
        m = icdf('Poisson',rand,lambda);
        Y = exp(m*(alphaJ - 0.5*volJump^2) + volJump*sum(randn(1,m)));
        ST(i) = ST(i)*Y;
    end
Intrinsic = max(0, K - ST);
price = mean(exp(-r*T)*Intrinsic);

