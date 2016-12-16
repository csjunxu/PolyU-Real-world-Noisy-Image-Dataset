clear;
Original_image_dir = '20161214/';
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
meanRaw = meanRaw./im_num;
imwrite(meanRaw,'mean_ARW_DNG_TIF.tiff');

