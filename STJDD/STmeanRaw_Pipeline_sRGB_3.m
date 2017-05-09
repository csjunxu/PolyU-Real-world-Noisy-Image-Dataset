clear;
Raw_image_dir = 'C:/Users/csjunxu/Desktop/TIP2017/RID_Dataset/DatasetTIP/SONY_A7II_ISO12800';
fpath = fullfile(Raw_image_dir, '*.ARW');
im_dir  = dir(fpath);
im_num = length(im_dir);
D = regexp(Raw_image_dir, '/', 'split');

%% get the name of Raw images
S = regexp(im_dir(1).name, '\.', 'split');
[~, ~] = system(['dcraw -4 -T -D -v C:\Users\csjunxu\Desktop\TIP2017\RID_Dataset\' D{end-1} '\' D{end} '\' S{1} '.ARW']);

%% get the precision information
get(0,'format');
% set the precision to long instead of short
set(0,'Format','long');

%% 0 read the ST mean image of format 'tiff'
method = 'B';
rawname = [D{end} '_' method];
Raw = double(imread(['STA_' rawname '.tiff']));
fprintf('Processing %s. \n', D{end});

% rawname = S{1};
% Raw = double(imread([Raw_image_dir '/' rawname '.tiff']));
% fprintf('Processing %s. \n', S{1});



%% get parameters of black/saturation and wb_multipliers
[status,cmdout] = system(['dcraw -w -v C:\Users\csjunxu\Desktop\TIP2017\RID_Dataset\' D{end-1} '\' D{end} '\' S{1} '.ARW']);

%% 1 Linearization
black = 128; % str2double(cmdout(148:150)); % 128
saturation = 4095; % str2double(cmdout(248:251)); % 4095
lin_bayer = (Raw-black)/(saturation-black); %  normailization to [0,1];
lin_bayer = max(0, min(lin_bayer,1)); % no value larger than 1 or less than 0;
% imshow(lin_bayer);
% imwrite(lin_bayer,[D{end} '_1Linearized.png']);
imwrite(lin_bayer,[rawname '_1Linearized.png']);

%% 2 White Balancing
wb_multipliers = [str2double(cmdout(270:277)), 1, str2double(cmdout(288:295))]; % for particular condition, from dcraw;
mask = wbmask(size(lin_bayer,1),size(lin_bayer,2),wb_multipliers,'rggb');
balanced_bayer = lin_bayer .* mask;
%     imshow(balanced_bayer);
% imwrite(lin_bayer,[D{end} '_2WhiteBalanced.png']);
imwrite(lin_bayer,[rawname '_2WhiteBalanced.png']);

%% 3 Demosaicking is problematic for the mean data
temp = uint16(balanced_bayer/max(balanced_bayer(:)) * (2^16-1));
lin_rgb = double(demosaic(temp,'rggb'))/(2^16-1);
%     imshow(lin_rgb);
% imwrite(lin_rgb,[D{end} '_3Demosaicked.png']);
imwrite(lin_rgb,[rawname '_3Demosaicked.png']);

%% 4 Color Space Conversion
sRGB2XYZ = [0.4124564 0.3575761 0.1804375;0.2126729 0.7151522 0.0721750;0.0193339 0.1191920 0.9503041];
% sRGB2XYZ is an unchanged standard
XYZ2Cam = [5271 -712 -347;-6153 13653 2763;-1601 2366 7242]/10000;
% Here XYZ2Cam is only for Sony ILCE-7M2, can be found in adobe_coeff in dcraw.c
sRGB2Cam = XYZ2Cam * sRGB2XYZ;
sRGB2Cam = sRGB2Cam./ repmat(sum(sRGB2Cam,2),1,3); % normalize each rows of sRGB2Cam to 1
Cam2sRGB = (sRGB2Cam)^-1;
lin_srgb = apply_cmatrix(lin_rgb, Cam2sRGB);
lin_srgb = max(0,min(lin_srgb,1)); % Always keep image clipped b/w 0-1
%     imshow(lin_srgb);
% imwrite(lin_srgb,[D{end} '_4ColorSpaceConversed.png']);
imwrite(lin_srgb,[rawname '_4ColorSpaceConversed.png']);

%% 5 Brightness and Gamma Correction
grayim = rgb2gray(lin_srgb); % Consider only gray channel
grayscale = 0.25/mean(grayim(:));
bright_srgb = min(1,lin_srgb * grayscale); % Always keep image value less than 1
nl_srgb = bright_srgb.^(1/2.2); % 2.4 in official documentation of sRGB
% imwrite(nl_srgb,[D{end} '_5BrightGammaCorrected.png']);
imwrite(nl_srgb,[rawname '_5BrightGammaCorrected.png']);

