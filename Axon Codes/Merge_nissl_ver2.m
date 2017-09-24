% This code merges images of binarized axons and their parent Nissl/DAPI images.
% Number and order of images must match.


clear
clc

scale = 0.25; % for resizing images. 1 is 100%. 

% put first few characters shared by Nissl/DAPI source images
list_blue = dir([pwd filesep 'normalized*']);   
files_blue = {list_blue.name}';
nImages_blue = length(files_blue);

% first few characters shared by binary images (detected axons)
list_green = dir([pwd filesep 'BW*']);   
files_green = {list_green.name}';
nImages_Green = length(files_green);

if nImages_blue ~= nImages_Green
    error('Number of Nissl/DAPI and binarized images do not match')
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
    
    filename = ['Merged_' num2str(k,'%03u') '.jpg'];
    imwrite(Merged,filename,'jpg', 'quality', 100);
    % "save as a jpeg" generates wierd psued color. Use tif. 
   
end


