function  main(filethread) 


%GEOMBEST is a morphological-behavior model that simulates barrier island evolution in response to changes in sea level and sediment supply rates

%Copyright (C) 2012 Laura J. Moore (current developer) and David Stolper (original author)

%Current developer can be contacted by email (laura.moore@unc.edu) or paper mail (Department of Geological Sciences, 104 South Road, Chapel Hill,27599-3015,USA)
%This program is free software; you can redistribute it and/or modify it under the terms of the GNU General Public License as published by the Free Software Foundation; either version 2 of the License, or any later version.
%This program is distributed in the hope that it will be useful, but WITHOUT ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE. See the GNU General Public License for more details.
%You should have received a copy of the GNU General Public License along with this program; if not, write to the Free Software Foundation, Inc., 51 Franklin Street, Fifth Floor, Boston, MA 02110-1301 USA.

% main -- main function of the Quicksand program
% Dr David Stolper dstolper@usgs.gov
% filethread specifies the input and output files used
% i.e. inpout1 to input4, output1 to  output4 

% Version of 26-Dec-2002 09:41
% Updated    29-Oct-2012 15:07

clear global;

global gridstrat; % 5-D raster representation of morphology/stratigraphy - grid(T,L,M,N,S)
global surface; % 2-D surface of the morphology at each timestep(t,i,j) 
global shorelines; % The x location of the shorelines (0 m elevation) of each tract at each time step shorelines(t,j)
global SL; % sea level relative to the original elevation SL(t)
global TP; % period of each timestep(yr)
global celldim; % 2-D array specifying cell dimensions 
global T; % # timestep
global L; % # grid cells along x axis
global M; % # grid cells along y axis 
global N; % # grid cells along z axis 
global S; % # stratigraphic units comprising the grid (excluding equilibrium horizon)  
global strat; % 2-D structure array (y,S) comprising .name, .sand, .erodibility and .elevation fields
global runfiles; % driving paramater values 
global erosionresponse; % depth-dependant response rate (m/yr)
global accretionresponse; % depth-dependant response rate (m/yr)
global xcentroids; % vector of cell centroids along the x axis
global zcentroids; % vector of cell centroids along the z axis
global equil; % 2-D array comprising crossshore equilibri um profiles (i,j)
global residual; % residual sediment volumes from the crossshore search algorithm
global zresponseerosion; % maximum shoreface response rate at the elevations specified by zcentroids
global zresponseaccretion; % maximum shoreface response rate at the elevations specified by zcentroids

loadrunfiles1(filethread); 
loadstrat1(filethread);   
loadrate1(filethread);
buildgrid;
zresponseerosion = interp1(erosionresponse(:,1),erosionresponse(:,2),zcentroids(:)); % calculate shoreface response rate at 
% elevations corresponding to the z centroids of each cell within the grid 
zresponseaccretion = interp1(accretionresponse(:,1),accretionresponse(:,2),zcentroids(:)); % calculate shoreface response rate at 
% elevations corresponding to the z centroids of each cell within the grid

residual = zeros(M); % residual sediment volume from each time step 

for j = 1:M
    findshoreline(0,j);
end

tic

savetimestep(1,1,filethread);

for t = 1:T % loop through time
   
    t % print timestep to screen
    
    for j = 1:M % loop through tracts  
        gridstrat(2,:,j,:,:) = gridstrat(1,:,j,:,:); 
        solvecross(t,j); % balance crossshore sediment budget        
    end
    savetimestep(2,t + 1,filethread); 
    gridstrat(1,:,:,:,:) = gridstrat(2,:,:,:,:);
    
    zresponseerosion = interp1(erosionresponse(:,1),erosionresponse(:,2),zcentroids(:) - SL(t)); % update shoreface response rate 
    zresponseaccretion = interp1(accretionresponse(:,1),accretionresponse(:,2),zcentroids(:) - SL(t)); % update shoreface response rate
    
    if t == 13 
        
        block = 0
        savedata(filethread) %added 5_20_08 LJM  If using debugger to stop 
        %the program at a desired time step, step forward to execute
        %the savedata command and then plotting functions can still be
        %used.

    end    
end 
 
savedata(filethread)

toc

block = 0;