clear;
%% mean Scene minus mean DF
% 128 is the reset value for Sony A7 II 
Original_image_dir = '20161230mean/';
reset = 128;
%% ALL
meanRawAll = imread([Original_image_dir 'meanRAWAll_ARW2TIF.tiff']);
meanDFTIFAll = imread([Original_image_dir 'meanDFAll_ARW2TIF.tiff']);
meanGTAll = meanRawAll - meanDFTIFAll + reset; 
imwrite(meanGTAll,[Original_image_dir 'RawGTAll_ARW2TIF.tiff']);
% meanDFpgmAll = imread([Original_image_dir 'meanDFAll_ARW2pgm.pgm']);
% meanGTAll = meanRawAll - meanDFpgmAll + reset; 
% imwrite(meanGTAll,[Original_image_dir 'RawGTAll_ARW2pgm.tiff']);

%% 500
meanRaw500 = imread([Original_image_dir 'meanRAW500_ARW2TIF.tiff']);
meanDFTIF500 = imread([Original_image_dir 'meanDF500_ARW2TIF.tiff']);
meanGT500 = meanRaw500 - meanDFTIF500 + reset; 
imwrite(meanGT500,[Original_image_dir 'RawGT500_ARW2TIF.tiff']);
% meanDFpgm500 = imread([Original_image_dir 'meanDF500_ARW2pgm.pgm']);
% meanGT500 = meanRaw500 - meanDFpgm500 + reset; 
% imwrite(meanGT500,[Original_image_dir 'RawGT500_ARW2pgm.tiff']);

fpath = fullfile(Original_image_dir, '*.tiff');
im_dir  = dir(fpath);
im_num = length(im_dir);
for i = 1:im_num
    %% 0 read the tiff image
    raw = double(imread(fullfile(Original_image_dir, im_dir(i).name)));
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    fprintf('%s : \n',rawname);
    
    %% 1 Linearization
    black = 128;
    saturation = 4095;
    lin_bayer = (raw-black)/(saturation-black); %  normailization to [0,1];
    lin_bayer = max(0,min(lin_bayer,1)); % no value larger than 1 or less than 0;
%     imshow(lin_bayer);
    
    %% 2 White Balancing
    wb_multipliers = [1.882813, 1, 1.843750]; % for particular condition, from dcraw;
    mask = wbmask(size(lin_bayer,1),size(lin_bayer,2),wb_multipliers,'rggb');
    balanced_bayer = lin_bayer .* mask;
%     imshow(balanced_bayer);
    
    %% 3 Demosaicking
    temp = uint16(balanced_bayer/max(balanced_bayer(:)) * (2^16-1));
    lin_rgb = double(demosaic(temp,'rggb'))/( );
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
end



