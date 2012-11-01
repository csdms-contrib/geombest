function savedata(filethread)

% savedata -- saves shorelines and the global variables required for
% printing   

% Dr David Stolper dstolper@usgs.gov

% Version of 15-Apr-2003 10:49
% Updated    15-Apr-2003 10:49

global shorelines;
global surface;
global strat;
global xcentroids;
global zcentroids;
global celldim;
global SL;

if(ispc) %add modification to make the code cross platform
    save (['../Output' num2str(filethread) '/shorelines.mat'], 'shorelines') 
    save (['../Output' num2str(filethread) '/surface.mat'], 'surface')
    save (['../Output' num2str(filethread) '/strat.mat'], 'strat')
    save (['../Output' num2str(filethread) '/xcentroids.mat'], 'xcentroids')
    save (['../Output' num2str(filethread) '/zcentroids.mat'], 'zcentroids')
    save (['../Output' num2str(filethread) '/celldim.mat'], 'celldim')
    save (['../Output' num2str(filethread) '/SL.mat'], 'SL')
elseif(isunix)
    save (['/home/faculty/lmoore/Geombest/Output' num2str(filethread) '/shorelines.mat'], 'shorelines') 
    save (['/home/faculty/lmoore/Geombest/Output' num2str(filethread) '/surface.mat'], 'surface')
    save (['/home/faculty/lmoore/Geombest/Output' num2str(filethread) '/strat.mat'], 'strat')
    save (['/home/faculty/lmoore/Geombest/Output' num2str(filethread) '/xcentroids.mat'], 'xcentroids')
    save (['/home/faculty/lmoore/Geombest/Output' num2str(filethread) '/zcentroids.mat'], 'zcentroids')
    save (['/home/faculty/lmoore/Geombest/Output' num2str(filethread) '/celldim.mat'], 'celldim')
    save (['/home/faculty/lmoore/Geombest/Output' num2str(filethread) '/SL.mat'], 'SL')
     
else
    error('Not Unix, Not PC!')
end
