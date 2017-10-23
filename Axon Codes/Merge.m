% This code maerges binarized axon images (BW_###.jpg) onto blue channels 
% (Nissl/DAPI) of their parent images (normalized_###.jgp).
% Number and order of the normalized and BW images must match

% After running this code, open images in Photoshop, serect ROI (one ROI for each image.
% if you have multiple ROI, you need to save multiple files), fill outside
% the ROI with pure red (make sure the outside of ROI is completely red - this is very important.
% If you don't find your target nucleus, fill the entire image with red) and save files. 
% File name should be "Merged_###_name of nucleus_right (or left)" for next pixel counting code. 


clear
clc

scale = 0.25; % for resizing images. 1 is 100%. 

list_blue = dir([pwd filesep 'normalized*']);   
files_blue = {list_blue.name}';
nImages_blue = length(files_blue);


list_green = dir([pwd filesep 'BW*']);   
files_green = {list_green.name}';
nImages_Green = length(files_green);

if nImages_blue ~= nImages_Green
    error('Number of Nissl/DAPI and binarized images does not match')
end

for k = 1:nImages_blue
    
    blue = imread(files_blue{k});
    blue = blue(:,:,3);
    
    
    green = imread(files_green{k});
    
    
    % generate a blank red channel
    [height, width, dimension] = size(blue);
    red = zeros(height, width);
    
    if scale ~= 1;
        red = imresize(red, scale, 'nearest');
        green = imresize(green, scale, 'nearest');
        blue = imresize(blue, scale, 'nearest');
    end
    
    Merged = cat(3, red, green, blue);
    
    filename = ['Merged_' num2str(k,'%03u') '.tif'];
    imwrite(Merged,filename,'tif');
    % "save as jpeg" will generates psued color. Use tif. 
   
end
