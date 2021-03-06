function saveblock(filethread) %declares the function as output
%filethread = filethread % outputs filethread to base workspace

%Running this file before closing the workspace after a GEOMBEST run that 
%was halted early using "block" will save workspace.mat, shorelines.mat, 
%surface.mat,%celldim.mat, gridstrat.mat,xcentroids.mat and strat.mat to the appropriate
%output folder.  

%Created by Laura Moore April-14-08

%surface = evalin('main', 'surface')
%save (['../Output' num2str(filethread) '/surface'], 'surface')

%evalin ('main', 'save ([''../Output'' num2str(filethread), ''/surface''], surface)')

surface = evalin('main', 'surface')



%evalin ('main', 'save ([''../Output'' num2str(filethread), ''/surface''], ''surface''')
%evalin ('main', 'save ([''../Output'' num2str(filethread), ''/surface''], ''surface''')
%evalin ('main', 'save ([''../Output'' num2str(filethread), ''/surface''], ''surface''')
%evalin ('main', 'save ([''../Output'' num2str(filethread), ''/shorelines''])')
%evalin ('main', 'save ([''../Output'' num2str(filethread), ''/celldim''])')
%evalin ('main', 'save ([''../Output'' num2str(filethread), ''/centroids''])')




%save (['../Output' num2str(filethread) '/workspace'])
%save (['../Output' num2str(filethread) '/surface'], 'surface')
%save (['../Output' num2str(filethread) '/shorelines'], 'shorelines')
%save (['../Output' num2str(filethread) '/celldim'], 'celldim')
%save (['../Output' num2str(filethread) '/xcentroids'], 'centroids')
%save (['../Output' num2str(filethread) '/gridstrat'], 'gridstrat')

 