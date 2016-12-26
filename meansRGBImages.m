clear;
%% mean of raw images
Original_image_dir = '20161226_ISO3200_5000/';
fpath = fullfile(Original_image_dir, '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);
sRGB = double(imread(fullfile(Original_image_dir, im_dir(1).name)));
meansRGB = zeros(size(sRGB)); 
for i = 1:im_num
    %% read the tiff image 
    sRGB = double(imread(fullfile(Original_image_dir, im_dir(i).name)));
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    fprintf('Processing %s. \n', rawname);
    meansRGB = meansRGB + sRGB;
end
meansRGB = uint8(meansRGB./im_num);
imshow(meansRGB);
imwrite(meansRGB,'20161226mean_ISO3200_5000/meansRGBAll_ARW2TIF_TIF2PNG.png');
clear sRGB meansRGB;

meansRGB = zeros(size(sRGB)); 
for i = 1:min(500,im_num)
    %% read the tiff image 
    sRGB = double(imread(fullfile(Original_image_dir, im_dir(i).name)));
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    fprintf('Processing %s. \n', rawname);
    meansRGB = meansRGB + sRGB;
end
meansRGB = uint8(meansRGB./im_num);
imshow(meansRGB);
imwrite(meansRGB,'20161226mean_ISO3200_5000/meansRGB500_ARW2TIF_TIF2PNG.png');
clear sRGB meansRGB;




