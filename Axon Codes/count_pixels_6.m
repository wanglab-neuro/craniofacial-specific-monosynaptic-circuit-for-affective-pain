
clear all
clc
%total number of white pixels
%white = sum(I) retuns answer as matrix
%black = sum(sum(I == 0)) returns total number of black pixels
list = dir([pwd filesep 'normalized*']);   
files = {list.name}';
nImages = length(files);

file_name = 'pixel values.txt';
file = fopen(file_name);

for k = 1:nImages
    I = imread(files{k});
    white = sum(sum(I));
    file = fopen(file_name);
    dlmwrite(file_name, white ,'-append','newline','pc','precision',10);
    
end
