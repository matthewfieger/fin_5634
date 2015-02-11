function GBMWithJumps(S,r,q,volStock,T,alphaJ,volJump,lambdaJ,NRandom)


	% volS => Volatility in the stock price.
	% alphaJ => How much we lose if there is a jump.
	% lambdaJ => the probability in 1 year that we see one jump.
	
	TimePoints = NRandom + 1; % Shift for 1 based indexing.
	path = zeros(1,TimePoints); % Empty vector.
	WithJumps = zeros(1,TimePoints); % Empty vector.
	path(1,1) = S; % Boundary condition.
	WithJumps(1,1) = S; %Boundary condition.
	dT = T/NRandom; % Divide the length by the number of random variables.
	drift = (r - q - 0.5*volStock^2)*dT; % With no jumps.
	alphaK = r - q - lambdaJ*(exp(alphaJ) - 1); % Take a little bit off the drift to account for the average accumulation of the jumps.
	driftK = (alphaK - 0.5*volStock^2)*dT; % If there is a jump.
	risk = volStock*sqrt(dT);
	lambda = lambdaJ*dT;

	for j = 1:NRandom
        Z = randn;
        X = exp(drift + risk*Z);
        path(1,j+1) = path(1,j)*X;
        X = exp(driftK + risk*Z);
        m = icdf('Poisson',rand,lambda);
        Y = exp(m*(alphaJ - 0.5*volJump^2) + volJump*sum(randn(1,m)));
        WithJumps(1,j+1) = WithJumps(1,j)*X*Y;
    end

	plot(1:TimePoints,path(1,:));
	hold on;
	plot(1:TimePoints,WithJumps(1,:));
	hold on;

end