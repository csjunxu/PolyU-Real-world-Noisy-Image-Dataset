clear;
%% mean of raw images
Original_image_dir = '20170108/';
fpath = fullfile(Original_image_dir, '*.JPG');
im_dir  = dir(fpath);
im_num = length(im_dir);
D = regexp(Original_image_dir, '/', 'split');
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
    if mod(i, 500) == 0
        meansRGB500 = uint8(meansRGBAll./i);
        %         imshow(meansRGB500);
        imwrite(meansRGB500,[D{1} 'mean/meansRGB' num2str(i) '.JPG']);
        clear meansRGB500;
    end
end
% meansRGBAll = uint8(meansRGBAll./im_num);
% % imshow(meansRGBAll);
% imwrite(meansRGBAll,[D{1} 'mean/meansRGBAll_ARW2TIF_TIF2PNG.JPG']);
% clear sRGB meansRGBAll;


