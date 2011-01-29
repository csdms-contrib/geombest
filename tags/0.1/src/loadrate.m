function loadrate(filethread) 

% loadrate -- reads an excel files containing the depth-dependant response rate 
% Popultes the response array which has elevation (m) as the the first column and response rate (m/yr) as the second column.

% Dr David Stolper dstolper@usgs.gov

% Version of 26-Dec-2002 14:21
% Updated    26-Dec-2002 14:21

global erosionresponse;
global accretionresponse;

%--LM cross platform file loading and set variables rootname and filename for consistency 8/27/05 
if(ispc)
    rootname = ['../Input' num2str(filethread)]; % directory containing response.xls
elseif(isunix)
   rootname = ['/home/faculty/lmoore/Geombest/Input' num2str(filethread)]; %directory containing response.xls
else
    error('Not Unix, Not PC!')
end

filename = '/erosionresponse.xls';

[numbers] = xlsread([rootname filename], 'Sheet1', 'a1:r2000', 'basic'); %LM change to basic mode to accomodate unix platform 8/27/05

rows = size(numbers,1);
for i = 1:rows
    erosionresponse(i,1) = numbers(i,1);
    erosionresponse(i,2) = numbers(i,2);
end


%--LM cross platform file loading and set variables rootname and filename for consistency 8/27/05 
if(ispc)
    rootname = ['../Input' num2str(filethread)]; % directory containing response.xls
elseif(isunix)
   rootname = ['/home/faculty/lmoore/Geombest/Input' num2str(filethread)]; %directory containing response.xls
else
    error('Not Unix, Not PC!')
end

filename = '/accretionresponse.xls';

[numbers] = xlsread([rootname filename], 'Sheet1', 'a1:r2000', 'basic'); %LM change to basic mode to accomodate unix platform 8/27/05

rows = size(numbers,1);
for i = 1:rows
    accretionresponse(i,1) = numbers(i,1);
    accretionresponse(i,2) = numbers(i,2);
end