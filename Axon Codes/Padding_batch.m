clear
clc

p = which('normalized_001.jpg');
filelist = dir([fileparts(p) filesep 'normalized_*.jpg']);
filenames = {filelist.name}'
nImages = length(filenames);

z_height = zeros(1, nImages);
z_width = zeros(1, nImages);

for k = 1:nImages
    info = imfinfo(filenames{k});
    %info = iminfo(I);
    Height = getfield(info, 'Height');
    Width = getfield(info, 'Width');
    z_height(k) = Height;
    z_width(k) = Width;
end

max_height = max(z_height);
max_width = max(z_width);

max_height = max_height + 500;
max_width = max_width + 500;

for k = 1:nImages
    I = imread(filenames{k});
    [x, y, z] = size(I);
    height = ceil((max_height - x)/2); % needs to be integer but fix and ceil generate 1-pixel error
    width = ceil((max_width - y)/2);
    padded = padarray(I,[height width]);
    padded = imcrop(padded, [0 0 max_width max_height]);
    filename = ['normalized_padded' num2str(k,'%03u') '.jpg']; 
    imwrite(padded,filename,'jpg','Quality',100);
end

