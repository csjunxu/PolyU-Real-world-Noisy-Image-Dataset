%% mean of dark frames
Original_image_dir = '20161226DF_ISO3200_5000/';
fpath = fullfile(Original_image_dir, '*.tiff');
im_dir  = dir(fpath);
im_num = length(im_dir);
rawDF = double(imread(fullfile(Original_image_dir, im_dir(1).name)));
meanDFAll = zeros(size(rawDF));
meanDF500 = zeros(size(rawDF));
for i = 1:im_num
    %% read the tiff image
    rawDF = double(imread(fullfile(Original_image_dir, im_dir(i).name)));
    if size(rawDF,1) ~= size(meanDFAll,1)
        rawDF = rot90(rawDF,3); % counter-clockwise
    end
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    %     fprintf('Processing %s. \n', rawname);
    meanDFAll = meanDFAll + rawDF;
    if i == min(500,im_num)
        meanDF500 = uint8(meanDFAll./min(500,im_num));
        %         imshow(meansRGB500);
        imwrite(meanDF500,'20161226mean_ISO3200_5000/meanDF500_ARW2TIF.tiff');
        clear meanDF500;
    end
end
meanDFAll = uint16(meanDFAll./im_num);
% imshow(meanDFAll);
imwrite(meanDFAll,['20161226mean_ISO3200_5000/meanDFAll_ARW2TIF.tiff']);
clear rawDF meanDFAll;

% fpath = fullfile(Original_image_dir, '*.pgm');
% im_dir  = dir(fpath);
% im_num = length(im_dir);
% rawDF = double(imread(fullfile(Original_image_dir, im_dir(1).name)));
% meanDFAll = zeros(size(rawDF));
% meanDF500 = zeros(size(rawDF));
% for i = 1:im_num
%     %% read the tiff image
%     rawDF = double(imread(fullfile(Original_image_dir, im_dir(i).name)));
%     S = regexp(im_dir(i).name, '\.', 'split');
%     rawname = S{1};
%     fprintf('Processing %s. \n', rawname);
%     meanDFAll = meanDFAll + rawDF;
%     if i <= min(500,im_num)
%         meanDF500 = meanDFAll;
%     end
%     if i == min(500,im_num)
%         meanDF500 = uint8(meanDF500./min(500,im_num));
%         %         imshow(meansRGB500);
%         imwrite(meanDF500,'20161226mean_ISO3200_5000/meanDF500_ARW2pgm.pgm');
%         clear meanDF500;
%     end
% end
% meanDFAll = uint16(meanDFAll./im_num);
% % imshow(meanDFAll);
% imwrite(meanDFAll,['20161226DF_ISO3200_5000/meanDFAll_ARW2pgm.pgm']);
% clear rawDF meanDFAll;