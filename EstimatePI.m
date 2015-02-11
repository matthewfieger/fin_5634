function PI = EstimatePI(N)
rand('twister',0);
count = 0;
for i=1:N
    x = rand;
    y = rand;
    if ((x-.5)^2 +(y-.5)^2 <=.5^2)
        count = count + 1;
    end
end
% expect N * (PI*r^2) / (1*1) = count
PI = 4*count/N;