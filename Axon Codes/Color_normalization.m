% This code nomarlizes brightness (RGB) of images by using "Ref.jpg" as a
% reference and flips images horizontally if the brighter side 
% (usually the brighter side is the injected side) is on the right.
% Prepare one nicely adjusted image (maybe by Photoshop) as a reference 
% image and name it as Ref.jpg. For the Ref image, section with extremely 
% bright labelling is not recommended (such as the cerebellum in which 
% the blue channel is unsusually bright).
% Make sure that you need to inspect all processed images to correct
% potential errors. Sections poor labeling cannot be flipped correctly.
% Use Padding_batch to make all images the same size. You can align your 
% sections using StackReg in ImageJ.   

clear
clc

filelist = dir(['*.jpg']);
filenames = {filelist.name}'
nImages = length(filenames);
Ref = imread('Ref.jpg');% put name of one image file from serial sections 


Rref = Ref(:,:,1);
Gref = Ref(:,:,2);
Bref = Ref(:,:,3);

Rref = im2double(Rref);
Gref = im2double(Gref);
Bref = im2double(Bref);

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
    %NormRGB = imrotate(NormRGB,-90, 'bicubic');
    
    % the following code determines which side (left-right) is brighter
    % and flips images horizontally if the brighter side is on the right.
    
    %R = imrotate(R,-90, 'bicubic');
    %Ibw = im2bw(R);
    %[x, y, z] = size(R);
    
    %left = sum(sum(Ibw(1:x, 1:y/2)));
    %right = sum(sum(Ibw(1:x, y/2:y)));
    
   % diff = left - right;

    %if diff <= 0 % change here opoosite way if you want briter side on the right.
    %   NormRGB =  flipdim(NormRGB ,2);
   % end
    
    filename = ['normalized_' num2str(k,'%03u') '.jpg']; %num2str: ex, num2str(pi), str = 3.1416
    imwrite(NormRGB,filename,'jpg','Quality',100);
end


