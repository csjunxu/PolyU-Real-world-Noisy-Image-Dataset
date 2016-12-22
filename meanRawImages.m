clear;
%% mean of raw images
Original_image_dir = '20161221/';
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
imwrite(meanRaw,['20161221mean/meanRAW_ARW2TIF.tiff']);
clear raw meanRaw;



