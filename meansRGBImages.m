clear;
%% mean of raw images
Original_image_dir = '20161226_ISO3200_5000/';
fpath = fullfile(Original_image_dir, '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);
sRGB = double(imread(fullfile(Original_image_dir, im_dir(1).name)));
meansRGBAll = zeros(size(sRGB));
meansRGB500 = zeros(size(sRGB));
for i = 1:im_num
    %% read the tiff image
    sRGB = double(imread(fullfile(Original_image_dir, im_dir(i).name)));
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
%     fprintf('Processing %s. \n', rawname);
    meansRGBAll = meansRGBAll + sRGB;
    meansRGB500 = meansRGB500 + sRGB;
    if i == min(500,im_num)
        meansRGB500 = uint8(meansRGB500./min(500,im_num));
        imshow(meansRGB500);
        imwrite(meansRGB500,'20161226mean_ISO3200_5000/meansRGB500_ARW2TIF_TIF2PNG.png');
        clear meansRGB500;
    end
end
meansRGBAll = uint8(meansRGBAll./im_num);
% imshow(meansRGBAll);
imwrite(meansRGBAll,'20161226mean_ISO3200_5000/meansRGBAll_ARW2TIF_TIF2PNG.png');
clear sRGB meansRGBAll;


