function [overwashvol,tempgrid] = Overwash (tempgrid,icrest,t,j,shorewidth);

% Overwash -- Infills the backbarrier via overwash and tidal inlet
% processes, updating tempgrid accordingly 

% Dr David Stolper dstolper@usgs.gov

% Version of 02-Jan-2003 10:47
% Updated    08-Apr-2003 4:47

global celldim;
global runfiles;
global L;
global N;
global equil;
global surface;
global zcentroids;

[bbwidth] = getbbwidth(t,j);
remainingwidth = bbwidth; % the unfilled proportion of the bacbarrier width
overwashvol = 0;
endmarinecellwidth = 0; % width of backbarrier deposits in the most landwards marine cell   

%%%%%%%%%%%%%%% Update the icrest cell %%%%%%%%%%%%%%%

% find the cell housing the equilibrium horizon    
for k = 1:N
    if (zcentroids(k) - celldim(3,j) ./ 2) < equil(icrest)  
        newsurfcell = k;
        break
    end
end 
           
% update the cells below the equilibrium cell and overwashvol    
for k = N:-1:newsurfcell + 1   
    cellstrat = squeeze(tempgrid(icrest,k,:));
    realratio = sum(cellstrat);
    if realratio ~= 1
        tempgrid(icrest,k,1) = tempgrid(icrest,k,1) + (1 - realratio);
        overwashvol = overwashvol + (1 - realratio) .* celldim(1,j) .* celldim(2,j) .* celldim(3,j); 
    end
end
    
% update the equilibrium cell   
    
targetratio = (equil(icrest) - (zcentroids(newsurfcell) - celldim(3,j) ./2)) ./ celldim(3,j);
    
% calculate how full the equilibrium cell is    
cellstrat = squeeze(tempgrid(icrest,newsurfcell,:));
realratio = sum(cellstrat);
    
% update the equilibrium cell and overwashvol
tempgrid(icrest,newsurfcell,1) = tempgrid(icrest,newsurfcell,1) + (targetratio - realratio); % updates the holocene stratigraphic constituent
overwashvol = overwashvol + (targetratio - realratio) .* celldim(1,j) .* celldim(2,j) .* celldim(3,j);

remainingwidth = remainingwidth - (celldim(1,j) - shorewidth);


%%%%%%%%%%%%%%% Update remaining i cells %%%%%%%%%%%%%%% 

cellproportion = 1;
i = icrest + 1;

while remainingwidth > 0 
    
    % find the cell housing the equilibrium horizon    
    for k = 1:N
        if (zcentroids(k) - celldim(3,j) ./ 2) < equil(i)  
            newsurfcell = k;
            break
        end
    end    

    if remainingwidth < celldim(1,j)
        cellproportion = remainingwidth ./ celldim(1,j);
    end
    
    % update the cells below the equilibrium cell and overwashvol    
    for k = N:-1:newsurfcell + 1   
        cellstrat = squeeze(tempgrid(i,k,:));
        realratio = sum(cellstrat);
        if realratio < cellproportion
            tempgrid(i,k,1) = tempgrid(i,k,1) + (cellproportion - realratio);
            overwashvol = overwashvol + (cellproportion - realratio) .* celldim(1,j) .* celldim(2,j) .* celldim(3,j); 
        end        
    end
    
    % update the equilibrium cell   
    
    targetratio = (equil(i) - (zcentroids(newsurfcell) - celldim(3,j) ./2)) ./ celldim(3,j) .* cellproportion;
    
    % calculate how full the equilibrium cell is    
    cellstrat = squeeze(tempgrid(i,newsurfcell,:));
    realratio = sum(cellstrat);
    
    % update the equilibrium cell and overwashvol
    
    if realratio < targetratio
        tempgrid(i,newsurfcell,1) = tempgrid(i,newsurfcell,1) + (targetratio - realratio); % updates the holocene stratigraphic constituent
        overwashvol = overwashvol + (targetratio - realratio) .* celldim(1,j) .* celldim(2,j) .* celldim(3,j);
    end
        
    remainingwidth = remainingwidth - celldim(1,j);     
    
    i = i + 1;    
end