function [strattotals] = strattally(gridstrat,t,j)

% strattally -- tallys the sediment volumes for each stratigraphic unit 
% for a tract within gridstrat 

% Dr David Stolper dstolper@usgs.gov

% Version of 23-Jan-2003 15:03
% Updated    23-Jan-2003 15:03

global L;
global M;
global N;
global S;
global celldim;

strattotals = zeros(S,1);

for i = 1:L
    for k = 1:N
        for s = 1:S
            strattotals(s) = strattotals(s) + gridstrat(t,i,j,k,s);
        end
    end
end

for s = 1:S
    strattotals(s,1) = strattotals(s,1) .* celldim(1,j) .* celldim(2,j) .* celldim(3,j);    
end