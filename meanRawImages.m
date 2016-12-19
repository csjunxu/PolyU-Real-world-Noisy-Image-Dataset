clear;
%% mean of raw images
Original_image_dir = '20161219/';
fpath = fullfile(Original_image_dir, '*.tiff');
im_dir  = dir(fpath);
im_num = length(im_dir);
raw = double(imread(fullfile(Original_image_dir, im_dir(1).name)));
meanRaw = zeros(size(raw)); 
for i = 1:im_num
    %% 0 read the tiff image
    raw = double(imread(fullfile(Original_image_dir, im_dir(i).name)));
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    fprintf('Processing %s. \n', rawname);
    meanRaw = meanRaw + raw;
end
meanRaw = round(meanRaw./im_num);
meanRaw = uint16(meanRaw);
imshow(meanRaw);
imwrite(meanRaw,'mean_RAW_ARW2TIF.tiff');
clear raw meanRaw;
%% 1 mean of dark frames
Original_image_dir = '20161213/';
fpath = fullfile(Original_image_dir, '*.tiff');
im_dir  = dir(fpath);
im_num = length(im_dir);
rawDF = double(imread(fullfile(Original_image_dir, im_dir(1).name)));
meanDF = zeros(size(rawDF)); 
for i = 1:im_num
    %% 0 read the tiff image
    rawDF = double(imread(fullfile(Original_image_dir, im_dir(i).name)));
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    fprintf('Processing %s. \n', rawname);
    meanDF = meanDF + rawDF;
end
meanDF = round(meanDF./im_num);
meanDF = uint16(meanDF);
imshow(meanDF);
imwrite(meanDF,'mean_DF_ARW_DNG_TIF.tiff');
clear rawDF meanDF;
%% mean Scene minus mean DF
meanGT = meanRaw - meanDF;
imwrite(meanGT,'mean_GT_ARW_DNG_TIF.tiff');



