clear;
%% mean of raw images
Original_image_dir = 'C:\Users\csjunxu\Desktop\Projects\RID_Dataset\20170121\';
% Get a list of all files and folders in this folder.
files = dir(Original_image_dir);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subdir = files(dirFlags);
% Print folder names to command window.
for k = 1 : length(subdir)
    if length(findstr(subdir(k).name, 'mean')) >= 1 || strcmp(subdir(k).name, '.') == 1 || strcmp(subdir(k).name, '..') == 1
        continue;
    end
    fprintf('Sub folder #%d = %s\n', k, subdir(k).name);
    sRGB_dir       =  fullfile(Original_image_dir, subdir(k).name);
    mean_dir       =  fullfile(Original_image_dir, [subdir(k).name 'mean']);
    if ~isdir(mean_dir)
        mkdir(mean_dir)
    end
    fpath = fullfile(sRGB_dir, '*.JPG');
    im_dir  = dir(fpath);
    im_num = length(im_dir);
    D = regexp(sRGB_dir, '\', 'split');
    sRGB = double(imread(fullfile(sRGB_dir, im_dir(1).name)));
    meansRGBAll = zeros(size(sRGB));
    meansRGB500 = zeros(size(sRGB));
    for i = 1:im_num
        %% read the tiff image
        sRGB = double(imread(fullfile(sRGB_dir, im_dir(i).name)));
        S = regexp(im_dir(i).name, '\.', 'split');
        rawname = S{1};
        %     fprintf('Processing %s. \n', rawname);
        meansRGBAll = meansRGBAll + sRGB;
        if mod(i, 500) == 0
            meansRGB500 = uint8(meansRGBAll ./ i);
            %         imshow(meansRGB500);
            imwrite(meansRGB500, [mean_dir '\' D{end} '_meansRGB' num2str(i) '.JPG']);
            clear meansRGB500;
            display(sprintf('Average: Access sample %d', i));
        end
    end
    meansRGBAll = uint8(meansRGBAll./im_num);
    % imshow(meansRGBAll);
    imwrite(meansRGBAll, [mean_dir '\' D{end} '_meansRGBAll.JPG']);
    clear sRGB meansRGBAll;
end
clear all;
