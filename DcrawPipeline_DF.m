clear;
Original_image_dir = '20161221DF/';
fpath = fullfile(Original_image_dir, '*.pgm');
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
    imshow(lin_bayer);
    
    %% 2 White Balancing
    wb_multipliers = [2.132813, 1, 1.730469]; % for particular condition, from dcraw;
    mask = wbmask(size(lin_bayer,1),size(lin_bayer,2),wb_multipliers,'rggb');
    balanced_bayer = lin_bayer .* mask;
    imshow(balanced_bayer);
    
    %% 3 Demosaicking
    temp = uint16(balanced_bayer/max(balanced_bayer(:)) * (2^16-1));
    lin_rgb = double(demosaic(temp,'rggb'))/(2^16-1);
    imshow(lin_rgb);
    
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
    imshow(lin_srgb);
    
    %% 5 Brightness and Gamma Correction
    grayim = rgb2gray(lin_srgb); % Consider only gray channel
    grayscale = 0.25/mean(grayim(:));
    bright_srgb = min(1,lin_srgb * grayscale); % Always keep image value less than 1
    nl_srgb = bright_srgb.^(1/2.2);
    imshow(nl_srgb);
    imwrite(nl_srgb,[Original_image_dir rawname '_pgm2PNG.png']);
end


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
    %     system('dcraw -v -T C:\Users\csjunxu\Desktop\Projects\RID_Dataset\checkparameters\DSC01613.ARW');
    black = 128;
    saturation = 4095;
    lin_bayer = (raw-black)/(saturation-black); %  normailization to [0,1];
    lin_bayer = max(0,min(lin_bayer,1)); % no value larger than 1 or less than 0;
    imshow(lin_bayer);
    
    %% 2 White Balancing
    %     system('dcraw -v -w C:\Users\csjunxu\Desktop\Projects\RID_Dataset\checkparameters\DSC01613.ARW');
    wb_multipliers = [2.132813, 1, 1.730469]; % for particular condition, from dcraw;
    mask = wbmask(size(lin_bayer,1),size(lin_bayer,2),wb_multipliers,'rggb');
    balanced_bayer = lin_bayer .* mask;
    imshow(balanced_bayer);
    
    %% 3 Demosaicking
    temp = uint16(balanced_bayer/max(balanced_bayer(:)) * (2^16-1));
    lin_rgb = double(demosaic(temp,'rggb'))/(2^16-1);
    imshow(lin_rgb);
    
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
    imshow(lin_srgb);
    
    %% 5 Brightness and Gamma Correction
    grayim = rgb2gray(lin_srgb); % Consider only gray channel
    grayscale = 0.25/mean(grayim(:));
    bright_srgb = min(1,lin_srgb * grayscale); % Always keep image value less than 1
    nl_srgb = bright_srgb.^(1/2.2);
    imshow(nl_srgb);
    imwrite(nl_srgb,[Original_image_dir rawname '_TIF2PNG.png']);
end

