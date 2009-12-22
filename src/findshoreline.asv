function findshoreline(t,j)

global strat;
global shorelines;


entries = size (strat(j,1).elevation,1);

for e = 1:entries
    if strat(j,1).elevation(e,2) >= 0
        upperx = strat(j,1).elevation(e,1);
        lowerx = strat(j,1).elevation(e - 1,1);
        upperz = strat(j,1).elevation(e,2);
        lowerz = strat(j,1).elevation(e - 1,2);        
        totalrise = upperz - lowerz;
        totalrun = upperx - lowerx;
        zlow = 0 - lowerz;
        lowratio = zlow ./ totalrise;
        shorelines(t + 1,j) = lowerx + (lowratio .* totalrun);
        break    
    end
end

block = 0;