clear;
%% mean of raw images
Original_image_dir = '20161219/';
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
meansRGB = round(meansRGB./im_num);
meansRGB = uint16(meansRGB);
imshow(meansRGB);
imwrite(meansRGB,'mean_sRGB_ARW2TIF.png');
clear sRGB meansRGB;



