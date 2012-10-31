function savetimestep(g,t,filethread)

% savetimestep -- saves a file called step_'t' which is the stratigraphic data 
% at simulation step t. This data comes from the timestep of gridstrat specified
% by 'g', remembering that g comprises only two timesteps. 

% Dr David Stolper dstolper@usgs.gov

% Version of 09-Apr-2003 11:51
% Updated    09-Apr-2003 17:00

global gridstrat;

n = int2str(t); while length(n)<4, n = ['0' n]; end
varname = ['step_' n];

if(ispc) %modification to make code cross platform
    filename = ['../Output' num2str(filethread) '/' varname '.mat'];
elseif(isunix)
    filename = ['/home/faculty/lmoore/Geombest/Output' num2str(filethread) '/' varname '.mat'];
else
    error('Not Unix, Not PC!')
end
  
    
eval ([varname ' = gridstrat(g,:,:,:,:);'])
save(filename,varname)