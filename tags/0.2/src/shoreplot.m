function shoreplot(filethread)

%Function to create, plot and output an array of time step and shoreline
%position.
%Filethread specifies the output file folder in which the shoreline.mat
%file is located, e.g., output1, output2, etc. 
%Created by L. Moore 2/11/06

clear
close all

load c:/Geombest/Output(filethread)/shorelines.mat

x=shorelines(:,1)


