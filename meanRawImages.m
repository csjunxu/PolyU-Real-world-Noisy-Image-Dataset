clear;
%% mean of raw images
Original_image_dir = '20161226_ISO3200_5000/';
fpath = fullfile(Original_image_dir, '*.tiff');
im_dir  = dir(fpath);
im_num = length(im_dir);
raw = double(imread(fullfile(Original_image_dir, im_dir(1).name)));
meanRaw = zeros(size(raw)); 
for i = 1:im_num
    %% read the tiff image
    raw = double(imread(fullfile(Original_image_dir, im_dir(i).name)));
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    fprintf('Processing %s. \n', rawname);
    meanRaw = meanRaw + raw;
end
meanRaw = uint16(meanRaw./im_num);
imshow(meanRaw);
imwrite(meanRaw,['20161226mean_ISO3200_5000/meanRAWAll_ARW2TIF.tiff']);
clear raw meanRaw;

clear;
%% mean of raw images
Original_image_dir = '20161226_ISO3200_5000/';
fpath = fullfile(Original_image_dir, '*.tiff');
im_dir  = dir(fpath);
im_num = length(im_dir);
raw = double(imread(fullfile(Original_image_dir, im_dir(1).name)));
meanRaw = zeros(size(raw)); 
for i = 1:min(500,im_num)
    %% read the tiff image
    raw = double(imread(fullfile(Original_image_dir, im_dir(i).name)));
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    fprintf('Processing %s. \n', rawname);
    meanRaw = meanRaw + raw;
end
meanRaw = uint16(meanRaw./min(500,im_num));
imshow(meanRaw);
imwrite(meanRaw,['20161226mean_ISO3200_5000/meanRAW500_ARW2TIF.tiff']);
clear raw meanRaw;



