function [overwashvol,tempgrid] = backbarrierinfill (tempgrid,icrest,shorewidth,t,j);

% Backbarrierinfill -- 
% 1) Infills the backbarrier via overwash and vertical accretion
% 2) Updates tempgrid 
% 3) Determines whether there is a surplus sediment volume after the backbarrier is infilled

% Dr David Stolper dstolper@usgs.gov

% Version of 02-Jan-2003 10:47
% Updated    08-Apr-2003 4:47

global strat;
global celldim;
global runfiles;
global TP;
global SL;
global xcentroids;
global zcentroids;
global L;
global N;
global S;
global equil;
global surface;


[resuspensionelevation] = getresuspensionelevation(t,j);
resuspensionelevation = resuspensionelevation + SL(t,j); % elevation at which estuarine mud is resuspended
[estrate] = getestrate(t,j);
estrate = estrate ./ 1000 .* TP(t); % rate of estuarine sedimentation 

% find the identifying number of the estuary

for s = 2:S
    if strcmp(strat(j,s).name,'estuary')
        estuary = s - 1;
        break
    end
end

% accrete the estuary

for i = icrest :L
           
    % find the elevation for estuary surface 
    newsurfval = surface(t,i,j) + estrate;
    if newsurfval > resuspensionelevation % + SL(t) recently commented out
        newsurfval = resuspensionelevation; % + SL(t) recently newly commented out
    end
        
    if newsurfval > surface(t,i,j)
    
        % find the cell housing the elevation of the top estuary horizon        
        for k = 1:N
            if newsurfval > zcentroids(k) - celldim(3,j) ./ 2
                newsurfcell = k;
                break
            end
        end        
        
        % calculate how full the top cell should be
        targetratio = (newsurfval - (zcentroids(newsurfcell) - celldim(3,j) ./ 2)) ./ celldim(3,j);

        %calculate how full the top cell is
        cellstrat = squeeze(tempgrid(i,newsurfcell,:));
        realratio = sum(cellstrat); 
          
        % update the cell housing the top elevation        
        tempgrid(i,k,estuary) = tempgrid(i,newsurfcell,estuary) + (targetratio - realratio); % updates the holocene stratigraphic constituent
        
        % update the cells below the top elevation        
        for k = newsurfcell + 1:N
            cellstrat = squeeze(tempgrid(i,k,:));
            realratio = sum(cellstrat);
            if realratio ~= 1
                tempgrid(i,k,estuary) = tempgrid(i,k,estuary) + (1 - realratio);
            else
                break
            end
        end
    end    
end

[overwashvol,tempgrid] = Overwash (tempgrid,icrest,t,j,shorewidth);