function loadstrat(filethread)

% loadstrat -- reads data tract# excel files and populates the strat
% structure and celldim array

% strat is a 2-D structure array (j,s) comprising .name, .sand, .erodibility and .elevation fields for each horizon 
% e.g. strat(2,1).name returns the name of the first horizon in tract2

% Note: The first horizon of each tract represents the active sand body,
% the second represents the estuary 

% The celldim array (2-D) has a column for each tract and rows representing celllength(i), cellwidth(j), 
% and cell height (k)  

% Dr David Stolper dstolper@usgs.gov

% Version of 26-Dec-2002 10:31
% Updated    26-Dec-2002 11:50

global S;
global strat;
global celldim;

strat = [];

%--LM cross platform file loading 8/27/05
if(ispc)
    rootname = ['../Input' num2str(filethread) '/tract']; % directory containing tract#files
elseif(isunix)
   rootname = ['/home/faculty/lmoore/Geombest/Input' num2str(filethread) '/tract']; % directory containing tract#files
else
    error('Not Unix, Not PC!')
end


flag = 1; % signifies whether a tract# file exists or not 
j = 0; % number of tract files in the rootname directory

while flag == 1
    filename = [rootname int2str(j + 1) '.xls'];
    col = 0; % the column within the excel file  
    
    if exist (filename) == 2 % ie the tract# exel file exists
        j = j + 1;
        [numbers,text]= xlsread(filename, 'Sheet1', 'a1:r2000', 'basic'); % reads the filename and creates two matrices representing: 1) the numbers, and 2) the text from the exel file 
                                                            %LM change to basic mode to accomodate unix platform 8/27/05
        S = (size(numbers,2) - 1) ./2 - 1; % determines the number of horizons (excluding the equilibrial morphology) within each tract  
        rows = size(numbers,1); % the number of rows in the numbers variable 
        
        %col=-1 %LJM- added 8/02/05 to shift column read over one to the left.  Program was reading in the wrong columns and returning an error.
        
        for s = 1:S + 1 % loops along each tract horizon 
            col = col + 2;
            h = []; % initialises the temporary holding variable 'h'
            h.name = text(4,col); % fills the .name field with horizon name 
            h.sand = numbers(5,col); % fills in the .sand field with sand proportion  
            h.erodibility = numbers(6,col); % fills in the .erodibility field with erodibility index
            h.totalpoints = numbers(7,col); % fills the .totalpoints field with the number of elevation data points 
            
                for i = 1:h.totalpoints % loops down the total data points
                    h.elevation(i,1) = numbers(i + 7,col);
                    h.elevation(i,2) = numbers(i + 7,col + 1);
                end
                
                if j == 1 & s == 1
                    strat = h; 
                else                
                    strat(j,s) = h; % creates a structure "h" to put into the "strat" array 
                end            
        end
        
        celldim(1,j) = numbers(1,2); % celllength
        celldim(2,j) = numbers(2,2); % cellwidth
        celldim(3,j) = numbers(3,2); % cellheight
        
    else 
        flag = 0; % ie the tractn file doesn't exist
    end
end