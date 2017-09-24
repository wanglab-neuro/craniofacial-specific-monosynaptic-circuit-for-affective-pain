% Select ROI (draw a circle around the target nucleus) in Photoshop
% Inverse selection and fill the outside of ROI with pure red
% make sure the outside of ROI is completely red by switching channels
% and checking the histogram - this is very important.
% If you don't find your target nucleus, fill the entire image with red.

clear all
clc


%%
[file_name, pathname] = uigetfile('*.jpg', 'multiselect', 'on');
% for i = 1: length(filename)
%     fileid{i} = file_name{i}(4: 7);
% end
%%

id = find(file_name{1} == '_', 1);
Nucleus = file_name{1}(1: id - 1)

n = 01; % put the number of start section
for i = 1: n
%     Nucleus = 'BNST';
    Direction = 'right'; % left or right
%     Direction = 'left'; % left or right
    str = 'left'; % do not change
    
    if strcmp(Direction, str)
        title = [Nucleus, '_', 'contralateral'];
%         file_names = '*left.tif';
    else
        title = [Nucleus '_' 'contralateral'];
%         file_names = '*right.tif';
    end
end

% list = dir([pwd filesep file_names]);   
files = file_name;
nImages = length(files);


for k = 1:nImages
    I = imread(files{k});
    [height, width, dim] = size(I);
    NumberOfTotalPixels = height*width;
    red_dots = (I(:,:,1)>127.5);
    n_red_dots = sum(red_dots(:));
    ROI_Area = NumberOfTotalPixels - n_red_dots;
    green_dots = (I(:,:,2)==255);
    n_green_dots = sum(green_dots(:));
    n_green_dots_set(k) = n_green_dots;
    n_green_dots_set = n_green_dots_set(:);
    ROI_Area_set(k) = ROI_Area;
    ROI_Area_set = ROI_Area_set(:);
   
end

number = (n:n -1 + nImages)';
M = [number n_green_dots_set ROI_Area_set];

TotalPositivePixelsInROIs = sum(n_green_dots_set);
TotalROIArea = sum(ROI_Area_set);

Density = (TotalPositivePixelsInROIs/TotalROIArea)*100;

fid = [title '.xlsx'];
header_1 = {'Section','Positive pixels','ROI area'};
header_2 = {'Total Positive pixels','Total ROI area'};
header_3 = {'Density  (% total pixel)'};

xlswrite(fid,header_1,'Sheet1','A1');
xlswrite(fid, M, 'Sheet1','A2');
xlswrite(fid, header_2, 'Sheet1', ['B' num2str(nImages + 2)]);
M2 = [TotalPositivePixelsInROIs TotalROIArea];
xlswrite(fid, M2, 'Sheet1', ['B' num2str(nImages + 3)]);
xlswrite(fid, header_3, 'Sheet1', ['C' num2str(nImages + 4)]);
xlswrite(fid, Density, 'Sheet1', ['C' num2str(nImages + 5)]);


%After filling outside the ROI with pure red,
%Photoshop generates pseudocolor (mixture of red and color inside the ROI)
%along the boundary. So Pixel counts before and after the "fill process" is
%are slightly different. This is not a big problem. For the best
%approximation, the threshold is set at 127.5.


