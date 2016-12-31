%% directory of dark frames
Original_image_dir = '20161230DF/';
fpath = fullfile(Original_image_dir, '*.ARW');
im_dir  = dir(fpath);
im_num = length(im_dir);
D = regexp(Original_image_dir, '/', 'split');
%% calculate mean RawDF images
S = regexp(im_dir(1).name, '\.', 'split');
rawname = S{1};
[status, ~] = system(['dcraw -4 -T -D -v C:\Users\csjunxu\Desktop\Projects\RID_Dataset\' D{1} '\' rawname '.ARW']);
RawDF = double(imread([Original_image_dir rawname '.tiff']));
meanDFAll = zeros(size(RawDF));
meanDF500 = zeros(size(RawDF));
%% get the precision information
get(0,'format');
% set the precision to long instead of short
set(0,'Format','long');
for i = 1:im_num
    %% 0 read the tiff image
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    [~, ~] = system(['dcraw -4 -T -D -v C:\Users\csjunxu\Desktop\Projects\RID_Dataset\' D{1} '\' rawname '.ARW']);
    RawDF = double(imread([Original_image_dir rawname '.tiff']));
    if size(RawDF,1) ~= size(meanDFAll,1)
        RawDF = rot90(RawDF,3); % counter-clockwise
    end
    fprintf('Processing %s. \n', rawname);
    meanDFAll = meanDFAll + RawDF;
    if i == min(500,im_num)
        meanDF500 = uint16(meanDFAll./min(500,im_num));
        %         imshow(meansRGB500);
        imwrite(meanDF500, [D{1}(1:8) 'mean/meanDF500_ARW2TIF.tiff']);
        clear meanDF500;
    end
    system(['del ' D{1} '\' rawname '.tiff']);
    %    system(['del ' D{1} '\' rawname '.ppm']);
    %    system(['del ' D{1} '\' rawname '.png']);
end
meanDFAll = uint16(meanDFAll./im_num);
% imshow(meanDFAll);
imwrite(meanDFAll, [D{1}(1:8) 'mean/meanDFAll_ARW2TIF.tiff']);
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