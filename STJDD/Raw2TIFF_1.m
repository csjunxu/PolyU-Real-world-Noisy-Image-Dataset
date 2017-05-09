clear;
Original_image_dir = '../DatasetTIP/SONY_A7II_ISO12800';
fpath = fullfile(Original_image_dir, '*.ARW');
im_dir  = dir(fpath);
im_num = length(im_dir);
D = regexp(Original_image_dir, '/', 'split');

%% calculate mean Raw images
S = regexp(im_dir(1).name, '\.', 'split');
rawname = S{1};
[status, ~] = system(['dcraw -4 -T -D -v C:\Users\csjunxu\Desktop\Projects\RID_Dataset\' D{1} '\' D{2} '\' rawname '.ARW']);
Raw = double(imread([Original_image_dir '/' rawname '.tiff']));
meanRawAll = zeros(size(Raw));
meanRaw500 = zeros(size(Raw));
%% calculate mean sRGB images
meansRGBAll = zeros([size(Raw),3]);
meansRGB500 = zeros([size(Raw),3]);

%% get the precision information
get(0,'format');
% set the precision to long instead of short
set(0,'Format','long');

for i = 1:im_num
    %% 0 read the tiff image
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    [~, ~] = system(['dcraw -4 -T -D -v C:\Users\csjunxu\Desktop\Projects\RID_Dataset\' D{1} '\' D{2} '\' rawname '.ARW']);
    Raw = double(imread([Original_image_dir '/' rawname '.tiff']));
    fprintf('Processing %s. \n', rawname);
end