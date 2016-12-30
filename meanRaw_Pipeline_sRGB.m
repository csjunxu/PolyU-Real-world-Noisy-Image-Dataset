clear;
Original_image_dir = '20161230/';
fpath = fullfile(Original_image_dir, '*.ARW');
im_dir  = dir(fpath);
im_num = length(im_dir);
D = regexp(Original_image_dir, '/', 'split');

%% calculate mean Raw images
S = regexp(im_dir(1).name, '\.', 'split');
rawname = S{1};
[status, ~] = system(['dcraw -4 -T -D -v C:\Users\csjunxu\Desktop\Projects\RID_Dataset\' D{1} '\' rawname '.ARW']);
Raw = double(imread([Original_image_dir rawname '.tiff']));
meanRawAll = zeros(size(Raw));
meanRaw500 = zeros(size(Raw));
%% calculate mean sRGB images
meansRGBAll = zeros([size(Raw),3]);
meansRGB500 = zeros([size(Raw),3]);

%% get the precision information
get(0,'format');
% set the precision to long instead of short
set(0,'Format','long');

for i = 1:im_num
    %% 0 read the tiff image
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    [~, ~] = system(['dcraw -4 -T -D -v C:\Users\csjunxu\Desktop\Projects\RID_Dataset\' D{1} '\' rawname '.ARW']);
    Raw = double(imread([Original_image_dir rawname '.tiff']));
    fprintf('Processing %s. \n', rawname);
    meanRawAll = meanRawAll + Raw;
    if i == min(500,im_num)
        meanRaw500 = uint16(meanRawAll./min(500,im_num));
        %         imshow(meanRaw500);
        imwrite(meanRaw500, [D{1} 'mean/meanRaw500_ARW2TIF.tiff']);
        clear meanRaw500;
    end
    
    %% get parameters of black/saturation and wb_multipliers
    [status,cmdout] = system(['dcraw -w -v C:\Users\csjunxu\Desktop\Projects\RID_Dataset\' D{1} '\' rawname '.ARW']);
    
    %% 1 Linearization
    black = str2double(cmdout(128:130));
    saturation = str2double(cmdout(144:147));
    lin_bayer = (Raw-black)/(saturation-black); %  normailization to [0,1];
    lin_bayer = max(0, min(lin_bayer,1)); % no value larger than 1 or less than 0;
    %     imshow(lin_bayer);
    
    %% 2 White Balancing
    wb_multipliers = [str2double(cmdout(166:173)), 1, str2double(cmdout(184:191))]; % for particular condition, from dcraw;
    mask = wbmask(size(lin_bayer,1),size(lin_bayer,2),wb_multipliers,'rggb');
    balanced_bayer = lin_bayer .* mask;
    %     imshow(balanced_bayer);
    
    %% 3 Demosaicking
    temp = uint16(balanced_bayer/max(balanced_bayer(:)) * (2^16-1));
    lin_rgb = double(demosaic(temp,'rggb'))/(2^16-1);
    %     imshow(lin_rgb);
    
    %% 4 Color Space Conversion
    sRGB2XYZ = [0.4124564 0.3575761 0.1804375;0.2126729 0.7151522 0.0721750;0.0193339 0.1191920 0.9503041];
    % sRGB2XYZ is an unchanged standard
    XYZ2Cam = [5271 -712 -347;-6153 13653 2763;-1601 2366 7242]/10000;
    % Here XYZ2Cam is only for Nikon D3X, can be found in adobe_coeff in dcraw.c
    sRGB2Cam = XYZ2Cam * sRGB2XYZ;
    sRGB2Cam = sRGB2Cam./ repmat(sum(sRGB2Cam,2),1,3); % normalize each rows of sRGB2Cam to 1
    Cam2sRGB = (sRGB2Cam)^-1;
    lin_srgb = apply_cmatrix(lin_rgb, Cam2sRGB);
    lin_srgb = max(0,min(lin_srgb,1)); % Always keep image clipped b/w 0-1
    %     imshow(lin_srgb);
    
    %% 5 Brightness and Gamma Correction
    grayim = rgb2gray(lin_srgb); % Consider only gray channel
    grayscale = 0.25/mean(grayim(:));
    bright_srgb = min(1,lin_srgb * grayscale); % Always keep image value less than 1
    nl_srgb = bright_srgb.^(1/2.2);
    %     imshow(nl_srgb);
    imwrite(nl_srgb,[Original_image_dir rawname '_TIF2PNG.png']);
    
    %% calculate mean sRGB images
    meansRGBAll = meansRGBAll + nl_srgb;
    if i == min(500,im_num)
        meansRGB500 = uint8(meansRGBAll./min(500,im_num));
        %         imshow(meansRGB500);
        imwrite(meansRGB500, [D{1} 'mean/meansRGB500_ARW2TIF_TIF2PNG.png']);
        clear meansRGB500;
    end
    system(['del ' D{1} '\' rawname '.tiff']);
    system(['del ' D{1} '\' rawname '.ppm']);
    %    system(['del ' D{1} '\' rawname '.png']);
end
meanRawAll = uint16(meanRawAll./im_num);
% imshow(meanRawAll);
imwrite(meanRawAll, [D{1} 'mean/meanRawAll_ARW2TIF.tiff']);
clear Raw meanRawAll cmdout;
meansRGBAll = uint8(meansRGBAll./im_num);
% imshow(meansRGBAll);
imwrite(meansRGBAll, [D{1} 'mean/meansRGBAll_ARW2TIF_TIF2PNG.png']);
clear sRGB meansRGBAll;


