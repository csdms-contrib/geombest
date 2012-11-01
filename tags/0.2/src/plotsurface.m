
function plotsurface(filethread,modelrun)

% Function to create, plot and output (eps and jpg) the surface at the first 
% and last time steps.  
% Filethread refers to the Input file folder in which files will be found.
% Plotsurface calculates average depth of erosion at points A, B and C

% Filethread specifies the output file folder in which the shoreline.mat
% file is located, e.g., output1, output2, etc. A, B and C are the alongshore 
% distances at which erosion depth is to be measured and averaged. 
% modelrun is the title to be given to the graph.   

% Created by L. Moore Jun-7-06

%cross platform file loading of surface.mat 
if(ispc)
   filename = ['../Output' num2str(filethread) '/surface.mat']; 
elseif(isunix)
   filename = ['../Output' num2str(filethread) '/surface.mat']; 
else
    error('Not Unix, Not PC!')
end

load(filename)

%load modern surface file
modsurf = xlsread('ModernSurface', 'Sheet1', 'a1:b5483', 'basic');

%assign variables for the modern surface
modx = modsurf (:,1)/1000; % Convert from meters to kilometers
mody = modsurf (:,2);

close all

%assign variables for surfaces at the first and last timesteps
y1 = surface(1,:); %create variable with values of surface elevations (at xcentroids) for first time step
yfinal = surface(end,:); %create variable with values of surface elevation (at xcentroids)for last time step


%cross platform file loading of xcentroids.mat 
if(ispc)
   filename2 = ['../Output' num2str(filethread) '/xcentroids.mat']; 
elseif(isunix)
   filename2 = ['../Output' num2str(filethread) '/xcentroids.mat']; 
else
    error('Not Unix, Not PC!')
end

load(filename2);

x = xcentroids(1,:)/1000; %create variable of xcentroids = distance and convert to km

% Calculate average depth of erosion at three distances
%dist1 = A ; %sets up a counter for first distance
 %   count = 1; % initializes a flag which will count through the values of x until statement below is true
  %      while x(count) < dist1; 
   %         count = count + 1; % keep adding 1 until x(count) is larger than dist1, 
            
    %    end
     %       elev1 = y1(count); % use int as the index of x (might be 30th element, for example)
       %this line is a comment             % to read the y value, elevation 
      %      elev1final = yfinal(count); 
        
      
%dist2= B ; %sets up a counter for second distance
 %  count = 1; % initializes int which will count through the values of x until statement below is true
  %   while x(count) < dist2; 
    %        count = count + 1; % keep adding 1 until x(int) is larger than dist1, 
   %  end
     %   elev2 = y1(count); % use int as the index of x (might be 30th element, for example) 
                    % to read the y value, elevation 
      %      elev2final = yfinal(count); 
 
%dist3 = C ; %sets up a counter for second distance
 %   count = 1; % initializes count which will count through the values of x until statement below is true
  %      while x(count) < dist3; 
   %         count = count + 1; % keep adding 1 until x(count) is larger than dist1, 
    %    end
     %       elev3 = y1(count); % use count as the index of x (might be 30th element, for example)
                    % to read the y value, elevation 
      %      elev3final = yfinal(count); 
        

%AveEdepth = ((elev1-elev1final)+(elev2-elev2final) + (elev3-elev3final))/3;

plot1 = plot(x,y1, 'color','b', 'linewidth',2.5);
hold on
plot1 = plot(x,yfinal, 'color', 'r', 'linewidth', 2.5);
hold on
plot1 = plot(modx,mody, '--', 'linewidth', 2.5); 

set(plot1,'Color',[0,0,0]);
xlabel('Distance (km)','FontSize',14);
ylabel('Elevation Relative to Initial Sea Level (m)','FontSize',14);    
set (gca, 'fontsize', 14,...
    'yminortick','on',...
    'xminortick','on',...
    'TickDir','out',...
    'XDir','reverse')
title((modelrun), 'fontsize', 15)
hold on
%text(135000,-40,['Average Depth of Erosion =' num2str(AveEdepth) ' m'], 'fontsize', 15);

%key for color lines
text(95,-15,'Initial Surface', 'fontsize', 15, 'color', 'b');
text(95,-22,'Model-generated Surface', 'fontsize', 15, 'color', 'r');
text(95,-29,'Modern Surface', 'fontsize', 15, 'color', 'k');

%set the dimensions of the plot so that it is longer in the x direction
%than in the y direction 
h= gcf;
x = get (h, 'position');
set (h, 'position', [x(1), x(2), 800, 400]); % 1st two numbers are location of plot, 3rd is x length, 4th is y length.

hold off;
saveas(plot1, ['../Output' num2str(filethread) '/psurface' num2str(modelrun) '.fig'])

saveas(plot1, ['../Output' num2str(filethread) '/psurface' num2str(modelrun) '.jpg'])
saveas(plot1, ['../Output' num2str(filethread) '/psurface' num2str(modelrun) '.pdf'])
saveas(plot1, ['../Output' num2str(filethread) '/psurface' num2str(modelrun) '.png'])

