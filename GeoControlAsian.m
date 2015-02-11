function [price, CI, Quality] = GeoControlAsian (S,K,r,T,sigma,q,NPoints,NR1,NR2)
tic
% Control Variate
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% The control variates method is a variance,
% reduction technique used in Monte Carlo methods.
% It exploits information about the errors in estimates,
% of known quantities to reduce the error,
% of an estimate of an unknown quantity.
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% STEP 1 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% Simulate "NR2" GBM paths of the underlying asset price,
% with "Npoints" steps per path.
Underlying = GBMPaths(S,r,q,sigma,T,NPoints,NR1);
% Calculate arithmetic average of underlying prices.
AVEPrice = mean(Underlying(:,2:NPoints+1) , 2);
% Calculate the payoff of the arithmetic option,
% and discount the price to present value.
Intrinsic = exp(-r*T)*max(0,AVEPrice - K);

% Calculate the payoff of a geometric option,
% and discount the price to present value.
Geo_Mean = geomean(Underlying(:,2:NPoints+1),2);
Geo_Price = exp(-r*T)*max(0,Geo_Mean - K);


% Calculate the variance reduction coefficient.
SampleCov = cov(Geo_Price,Intrinsic);
c = SampleCov(1,2)/var(Geo_Price);
dT=T/NPoints;


% Calculate the known analytical solution,
% for a geometric asian option.
sigma_a = sigma/sqrt(3);
b_a = .5*(r-q-(sigma^2)/6);
d1 = (log(S/K) + (b_a + (sigma_a^2)/2 )*T)/(sigma_a*sqrt(T));
d2 = d1 - sigma_a*sqrt(T);
Expected_Geo_Price = S*exp((b_a-r)*T)*normcdf(d1) - K*exp(-r*T)*normcdf(d2);

% STEP 2 %
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

% Discard the first GBM simulation to avoid bias.
Underlying = GBMPaths(S,r,q,sigma,T,NPoints,NR2);

% Calculate the expected payoff again,
% of the arithmetic asian option.
AVEPrice = mean(Underlying(:,2:NPoints+1) , 2);
Intrinsic = exp(-r*T)*max(0,AVEPrice - K);

% Calculate the expected payoff again,
% of the geometric asian option,
% using the simulate GBM.
Geo_Mean = geomean(Underlying(:,2:NPoints+1),2);
Geo_Price = exp(-r*T)*max(0,Geo_Mean - K);
% Calculate the adjusted price.
ControlVar = Intrinsic - c*(Geo_Price - Expected_Geo_Price);
[price, XX, CI] = normfit(ControlVar);
Quality = (CI(2)-CI(1))/price/2;
toc
