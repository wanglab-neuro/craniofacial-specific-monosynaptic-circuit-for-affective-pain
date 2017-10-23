% This code nomarlizes contrast/brightness of images by using "Ref.jpg" as a
% reference.
%
% Adjust contrast/brightness of an image using Levels funtion in Photoshop 
% or ImageJ
%   Dragging the black point slider to the left edge of the histogram.
%   Dragging the white point slider to the right edge of the histogram.
%   Repeat this for all RGB chanells (unused channel must be black). 
%   Save the adjusted image as "Ref.jpg".
% All image files to be analyzed and "Ref.jpg" should be in the same folder


clear
clc

filelist = dir(['*.jpg']);
filenames = {filelist.name}'
nImages = length(filenames);

% Read the adjusted reference image
Ref = imread('Ref.jpg');

Rref = Ref(:,:,1);
Gref = Ref(:,:,2);
Bref = Ref(:,:,3);

Rref = im2double(Rref);
Gref = im2double(Gref);
Bref = im2double(Bref);

% normalize images
for k = 1:nImages
    I = imread(filenames{k});
    I = im2double(I);
    
    R = I(:,:,1);
    G = I(:,:,2);
    B = I(:,:,3);
    
    NormR = imhistmatch(R,Rref);
    NormG = imhistmatch(G,Gref);
    NormB = imhistmatch(B,Bref);
    
    NormR = repmat(uint8(255.*NormR),[1 1 3]);
    NormG = repmat(uint8(255.*NormG),[1 1 3]);
    NormB = repmat(uint8(255.*NormB),[1 1 3]);
    
    NormR = NormR(:,:,1);
    NormG = NormG(:,:,2);
    NormB = NormB(:,:,3);
    
    NormRGB = cat(3, NormR, NormG, NormB);
 
    % save normalized images
    filename = ['normalized_' num2str(k,'%03u') '.jpg']; 
    imwrite(NormRGB,filename,'jpg','Quality',100);
end
