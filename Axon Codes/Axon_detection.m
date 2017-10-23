% This code binalizes signals using canny edge detection and
% activecontour functions. 


clear
clc

list = dir([pwd filesep 'normalized*']);   
files = {list.name}';
nImages = length(files);

for k = 1:nImages
    I = imread(files{k});
    I = I(:, :, 2); % if the signal is red I(:, :, 1); 
    I = im2double(I);
    I = I.^1.25; % enhance contrast

    I = medfilt2(I,[2 2]); % remove noise
    BW = edge(I,'canny', 0.15); % edge detection
    
    % dilate detected edges to generate a mask for activecontour
    se = strel('disk',2);
    mask = imdilate(BW, se);
    
    % shrink the mask to fit signals and further remove noise
    % around real signals
    mask1 = activecontour(I, mask, 5);
    mask1 = bwareaopen(mask1, 3);

    % generate a cleaner mask
    mask2 = activecontour(I, mask1, 5);
    mask2 = bwareaopen(mask2, 3);
    mask2 = imclose(mask2, se); 
    

    % Further shrink the mask for the final detection.
    % In addition, the follwoing codes remove unwanted spiny-shape areas 
    % surrounding the mask (axons) and supress background signals.   
    mask3 = bwmorph(mask2, 'thin', 10);
    mask3 = bwmorph(mask3, 'spur', 10);
    mask3 = bwareaopen(mask3, 5);
    mask3 = bwmorph(mask3, 'dilate', 2);
    signals = activecontour(I, mask3, 50);
    signals = bwareaopen(signals, 5);
   
    filename = ['BW_' num2str(k,'%03u') '.jpg']; 
    imwrite(signals,filename,'Quality',100);
end

