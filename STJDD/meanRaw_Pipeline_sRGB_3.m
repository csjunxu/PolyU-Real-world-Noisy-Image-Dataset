clear;
Raw_image_dir = 'C:/Users/csjunxu/Desktop/TIP2017/RID_Dataset/DatasetTIP/SONY_A7II_ISO12800';
fpath = fullfile(Raw_image_dir, '*.ARW');
im_dir  = dir(fpath);
im_num = length(im_dir);
D = regexp(Raw_image_dir, '/', 'split');

%% calculate mean Raw images
S = regexp(im_dir(1).name, '\.', 'split');
rawname = S{1};
[~, ~] = system(['dcraw -4 -T -D -v C:\Users\csjunxu\Desktop\TIP2017\RID_Dataset\' D{end-1} '\' D{end} '\' rawname '.ARW']);
Raw = double(imread([Raw_image_dir '/' rawname '.tiff']));
meanRawAll = zeros(size(Raw));
meanRaw500 = zeros(size(Raw));
%% calculate mean sRGB images
meansRGBAll = zeros([size(Raw),3]);
meansRGB500 = zeros([size(Raw),3]);

%% get the precision information
get(0,'format');
% set the precision to long instead of short
set(0,'Format','long');

%% 0 read the tiff image
S = regexp(im_dir(1).name, '\.', 'split');
rawname = S{1};
[~, ~] = system(['dcraw -4 -T -D -v C:\Users\csjunxu\Desktop\TIP2017\RID_Dataset\' D{end-1} '\' D{end} '\' rawname '.ARW']);
%     Raw = double(imread([Raw_image_dir '/' rawname '.tiff']));
Raw = double(imread('STA_SONY_A7II_ISO12800_B.tiff'));
fprintf('Processing %s. \n', rawname);

%% get parameters of black/saturation and wb_multipliers
[status,cmdout] = system(['dcraw -w -v C:\Users\csjunxu\Desktop\TIP2017\RID_Dataset\' D{end-1} '\' D{end} '\' rawname '.ARW']);

%% 1 Linearization
black = str2double(cmdout(148:150));
saturation = str2double(cmdout(164:167));
lin_bayer = (Raw-black)/(saturation-black); %  normailization to [0,1];
lin_bayer = max(0, min(lin_bayer,1)); % no value larger than 1 or less than 0;
%     imshow(lin_bayer);
% imwrite(lin_bayer,[D{end} '_1Linearized.png']);
imwrite(lin_bayer,[S{1} '_1Linearized.png']);

%% 2 White Balancing
wb_multipliers = [str2double(cmdout(186:193)), 1, str2double(cmdout(204:211))]; % for particular condition, from dcraw;
mask = wbmask(size(lin_bayer,1),size(lin_bayer,2),wb_multipliers,'rggb');
balanced_bayer = lin_bayer .* mask;
%     imshow(balanced_bayer);
% imwrite(lin_bayer,[D{end} '_2WhiteBalanced.png']);
imwrite(lin_bayer,[S{1} '_2WhiteBalanced.png']);

%% 3 Demosaicking
temp = uint16(balanced_bayer/max(balanced_bayer(:)) * (2^16-1));
lin_rgb = double(demosaic(temp,'rggb'))/(2^16-1);
%     imshow(lin_rgb);
% imwrite(lin_rgb,[D{end} '_3Demosaicked.png']);
imwrite(lin_rgb,[S{1} '_3Demosaicked.png']);

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
imwrite(lin_srgb,[S{1} '_4ColorSpaceConversed.png']);

%% 5 Brightness and Gamma Correction
grayim = rgb2gray(lin_srgb); % Consider only gray channel
grayscale = 0.25/mean(grayim(:));
bright_srgb = min(1,lin_srgb * grayscale); % Always keep image value less than 1
nl_srgb = bright_srgb.^(1/2.2);
%     imshow(nl_srgb);
% imwrite(nl_srgb,[D{end} '_5BrightGammaCorrected.png']);
imwrite(nl_srgb,[S{1} '_5BrightGammaCorrected.png']);



