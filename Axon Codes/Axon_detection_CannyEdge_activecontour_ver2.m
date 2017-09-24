% This code binalizes axons using canny edge detection and
% activecontour functions. This code seems to be much roboust than Hessian 
% feature detection in imageJ, in terms of detecting weak signals and not
% detecting background signals.
% Still requires well adjusted images. Make sure preparing a nicely adjusted 
% reference image for Normalization code.

clear
clc

list = dir([pwd filesep 'normalized*']);   
files = {list.name}';
nImages = length(files);

for k = 1:nImages
    I = imread(files{k});
    I = I(:, :, 2);
    I = im2double(I);
    I = I.^1.25; %1.25

    I = medfilt2(I,[2 2]); % remove salt & pepper noise
    BW = edge(I,'canny', 0.15); %0.17
    
    % detect edges and dilate detected edges to generate a mask for activecontour 
    se = strel('disk',2);
    mask = imdilate(BW, se);
    
    % shrink the mask to fit signals and further remove salt & pepper noise
    % around real signals
    mask1 = activecontour(I, mask, 5);
    mask1 = bwareaopen(mask1, 3);

    % generate a cleaner mask
    mask2 = activecontour(I, mask1, 5);
    mask2 = bwareaopen(mask2, 3);
    mask2 = imclose(mask2, se); % ???
    

    % Further shrink a mask for the final detection.
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

