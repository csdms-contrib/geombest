function plottractcolour (filethread,t,j,fir,incr,modelrun)

% plottract -- plots a raster representation of the tract, superimposed with a surface line  
% t = last time step, j = tract number, fir = the first shadow surface to plot, incr = the number of timesteps 
% between each plotted shadow barrier, modelrun=the title of the model run to be printed as the title 
% of the plot. Modelrun input argument must be placed in single quotes. See
% users guide for details.

% Dr David Stolper dstolper@usgs.gov

% Version of 27-Dec-2002 16:16
% Updated    15-Apr-2003 11:32

global strat;
global surface;
global xcentroids;
global zcentroids;
global celldim;
global SL;

close all

% load the grid representation of the tract from the hard-drive

n = int2str(t); while length(n)<4, n = ['0' n]; end
varname = ['step_' n];
filename = ['C:\GEOMBEST\Output' num2str(filethread) '\' varname '.mat'];
temp = load (filename , varname);
eval (['gridtimestep =  temp.' varname ';']);

L = size(gridtimestep,2);
M = size(gridtimestep,3);
N = size(gridtimestep,4);
S = size(gridtimestep,5);

% load global variables from the hard-drive if they exist 

dirname = ['C:\GEOMBEST\Output' num2str(filethread) '\'];

if exist([dirname 'surface.mat']) == 2
    load ([dirname 'surface.mat'])
end
if exist([dirname 'xcentroids.mat']) == 2
    load ([dirname 'xcentroids.mat'])
end
if exist([dirname 'zcentroids.mat']) == 2
    load ([dirname 'zcentroids.mat'])
end
if exist([dirname 'strat.mat']) == 2
    load ([dirname 'strat.mat'])
end
if exist([dirname 'celldim.mat']) == 2
    load ([dirname 'celldim.mat'])
end
if exist([dirname 'SL.mat']) == 2
    load ([dirname 'SL.mat'])
end
    
    
enteredj = j;

% find the maximum elevation of the gridtimestep 

for j = 1:M
    for s = 2:S+1
        if ~isempty(strat(j,s).elevation) % ensures that only existing horizons are operated on 
            maxz(s) = max(strat(j,s).elevation(:,2)); % determines the maximum z value for each horizon
        end
    end
end

j = enteredj;

overallmaxz = max(maxz); % determines the overall maximum z value 

% create tractcolor colormap

tractcolor(1,:) = [1,1,1]; % white
tractcolor(2,:) = [0.5,0.5,1]; % blue

for s = 2:S + 1
    if strcmp(strat(j,s).name,'active sand body')
        tractcolor(s + 1,:) = [1,1,0]; % yellow
    elseif strcmp(strat(j,s).name,'estuary')
        tractcolor(s + 1,:) = [.75,0.75,.16]; % orange
    elseif strcmp(strat(j,s).name,'strat1')
        tractcolor(s + 1,:) = [0.35,0.35,.35]; % grey    
    elseif strcmp(strat(j,s).name,'strat2')
        tractcolor(s + 1,:) = [.68,0.58,.16]; % brown
    elseif strcmp(strat(j,s).name,'strat3')
        tractcolor(s + 1,:) = [.55, .44,.15]; % lighter brown
    elseif strcmp(strat(j,s).name,'strat4')
        tractcolor(s + 1,:) = [.44,.30,.02]; % dark brown
    elseif strcmp(strat(j,s).name,'strat5')
        tractcolor(s + 1,:) = [.38,.28,.06]; % darker brown
    end
end

colormap(tractcolor);

% create 2-D representation "tract"

if t == 1 
    for i = 1:L
        for k = 1:N
            [val,in] = max(gridtimestep(1,i,j,k,:));
            tract(k,i) = in + 2; % array of indices representing the dominant stratigraphy within each cell
            if val == 0 
                a = GreaterOrEqual(overallmaxz - k .* celldim(3,j),0);
                if a == 1 
                    tract(k,i) = 1; %air
                else
                    tract(k,i) = 2; % water
                end
            end                
        end
    end
else
    for i = 1:L
        for k = 1:N
            [val,in] = max(gridtimestep(1,i,j,k,:));
            tract(k,i) = in + 2; % array of indices representing the dominant stratigraphy within each cell
            if val == 0 
                a = GreaterOrEqual(overallmaxz - k .* celldim(3,j),SL(t-1,j));
                if a == 1;  
                    tract(k,i) = 1; %air
                else
                    tract(k,i) = 2; % water
                end
            end                
        end
    end
    
end

% determines maximum and minimum values for display

xcentroids = xcentroids/1000;   % LJM 3/22/06: divide by 1000 to put in km
xmin = min(xcentroids) - celldim(1,j)/1000 ./ 2;  %LJM 3/22/06 : add divide by 1000 to change cell dim to m
xmax = max(xcentroids) + celldim(1,j)/1000 ./ 2;  %LJM 3/22/06 : add divide by 1000 to change cell dim to m
zmin = min(zcentroids) - celldim(3,j) ./ 2;
zmax = max(zcentroids) + celldim(3,j) ./ 2;

% plot routine 

hold on;
image(xcentroids,zcentroids,tract); % plot colors for the tract at time t
axis([xmin,xmax,zmin,zmax]); % set axis limits

for step = fir:incr:t
    zeds = squeeze(surface(step,:,j));
    plot1 = plot (xcentroids,zeds,'linewidth',0.5); % plot shadow surfaces
    set(plot1,'Color',[0,0,0]);
end

zeds = squeeze(surface(t,:,j));
plot1 = plot (xcentroids,zeds,'linewidth',1.5); % plot surface at step t
    
set(plot1,'Color',[0,0,0]);
xlabel('Distance (km)','FontSize',14);
ylabel('Elevation Relative to Initial Sea Level (m)','FontSize',14);    
set (gca, 'fontsize', 14,...
    'yminortick','on',...
    'xminortick','on',...
    'TickDir','out',...
    'XDir','reverse')
title((modelrun), 'fontsize', 15)

%set the dimensions of the plot so that it is longer in the x direction
%than in the y direction 
h= gcf;
x = get (h, 'position');
set (h, 'position', [x(1), x(2), 800, 400]); % 1st two numbers are location of plot, 3rd is x length, 4th is y length.
    
hold off;
outputfilename = ['../Output' num2str(filethread) '/ptractcolour' num2str(modelrun)];

%print('-dill',outputfilename)- isn't including grayscale
saveas(plot1, ['../Output' num2str(filethread) '/ptractcolour' num2str(modelrun) '.fig'])
print('-dpdf',outputfilename)
print('-djpeg', outputfilename)
