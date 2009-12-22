function saveblock(filethread)

%Running this file before closing the workspace after a GEOMBEST run that 
%was halted early using "block" will save shorelines.mat, surface.mat, 
%celldim.mat, gridstrat.mat,xcentroids.mat and strat.mat to the appropriate
%output folder.  

%Created by Laura Moore April-14-08




 save( '../Output' num2str(filethread) '/surface' , 'surface')
 %save('shorelines', 'shorelines')
 %save('gridstrat', 'gridstrat')
 %save('celldim', 'celldim')
 %save('xcentroids', 'xcentroids')
 