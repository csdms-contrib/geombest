function loadrunfiles(filethread) 

% loadrunfiles -- reads data from the run# excel files
% creates runfiles structure array, comprising a series of run# structures
% each run# structure comprises .time, .sealevel, .estrate, .estsand, .bbvol, .exovol, and .resus fields 
% each of these fields is a vector of length T that defines parameter values at each timestep
% the function also creates SL(t) which records the sea level at each
% timestep, relative to the initial time step, and TP(t) which records the
% timeperiod (yrs) of each timestep 

% Dr David Stolper dstolper@usgs.gov

% Version of 26-Dec-2002 10:31
% Updated    10-Apr-2003 13:11

global runfiles;
global T;
global M;
global TP; % number of years at each time step
global SL;

%--LM cross platform file loading 8/27/05
if(ispc)
    rootname = ['../Input' num2str(filethread) '/run']; % directory containing runfiles
elseif(isunix)
   rootname = ['/home/faculty/lmoore/Geombest/Input' num2str(filethread) '/run']; % directory containing runfiles
else
    error('Not Unix, Not PC!')
end

flag = 1; % indicates the existence of a run# file 
M = 0; % number of run# files (and therefore tracts) in the rootname directory
cols = 6; % number of columns in the excel files

while flag == 1
    filename = [rootname int2str(M + 1) '.xls'];
    col = 0;    
    
    if exist (filename) == 2 
        M = M + 1;
        numbers = xlsread(filename, 'Sheet1', 'a1:r2000', 'basic');  %LM change to basic mode to accomodate unix platform 8/27/05
        T = size(numbers,1) - 2;         
        
        for row = 1:T                
                runfiles(M).time(row) = numbers(row + 2,1); % yr
                runfiles(M).sealevel(row)= numbers(row + 2,2); % change in sea level (m)
                runfiles(M).estrate(row) = numbers(row + 2,3); % rate of estuarine accretion (mm/yr)
                runfiles(M).estsand(row) = numbers(row + 2,4); % proportion of sand in the estuary deposits 
                runfiles(M).bbwidth(row) = numbers(row + 2,5); % backbarrier width (overwash and dlood-tide-delta deposits landwards of the barrier crest
                runfiles(M).exovol(row) = numbers(row + 2,6); % sand volume added to the tract via longshore deposition or sand nourishment (m3)
                runfiles(M).resus(row) = numbers(row + 2,7); % estuarine resuspension elevation (m)               
        end         
    else 
        flag = 0; % the run# file doesn't exist
    end
end

T = T .* numbers(1,3); % updates T to include substeps 

% build TP

for substep = 1:numbers(1,3)
    TP(substep) = runfiles(1).time(1) ./ numbers(1,3);    
end


t = numbers(1,3) + 1;
for fullstep = 2: T ./ numbers(1,3)
    for substep = 1:numbers(1,3)        
        if t ~= 1        
            TP(t) = (runfiles(1).time(fullstep) - runfiles(1).time(fullstep - 1)) ./ numbers(1,3);              
        end  
        t = t + 1;
    end     
end
    
% build SL

for j = 1:M
    cumulativesealevel = 0;    
    for substep = 1:numbers(1,3)
        cumulativesealevel = cumulativesealevel + runfiles(j).sealevel(1) ./ numbers(1,3);
        SL(substep,j) = cumulativesealevel;    
    end

    t = numbers(1,3) + 1;
    for fullstep = 2: T ./ numbers(1,3)
        for substep = 1:numbers(1,3)        
            if t ~= 1        
                cumulativesealevel = cumulativesealevel + (runfiles(j).sealevel(fullstep) - runfiles(j).sealevel(fullstep - 1)) ./ numbers(1,3);
                SL(t,j) = cumulativesealevel;             
            end  
            t = t + 1;
        end     
    end
end