clear;
Original_image_dir = 'C:/Users/csjunxu/Desktop/TIP2017/RID_Dataset/DatasetTIP/SONY_A7II_ISO12800';
fpath = fullfile(Original_image_dir, '*.tiff');
im_dir  = dir(fpath);
im_num = length(im_dir);
D = regexp(Original_image_dir, '/', 'split');
S = regexp(im_dir(1).name, '\.', 'split');


method = 'B';

% K is the number of samples for temparal frames
K = 10;
sam_num = min(im_num, K);
%% calculate mean TIFF images
Raw = imread([Original_image_dir '/' S{1} '.tiff']);
[h, w, ch] = size(Raw);
W = 6; % size of the window for averaging
hm = floor(h/W);
wm = floor(w/W);
chm = ch;

% each WxW patch can be transformed to a 'RGGB' patch
if strcmp(method, 'A')==1
    STsubRaw = zeros(2*hm, 2*wm, chm, 'uint16');
    for i = 1:sam_num
        S = regexp(im_dir(i).name, '\.', 'split');
        Raw = imread([Original_image_dir '/' S{1} '.tiff']);
        SsubRaw = spatialaverageA(Raw, W);
        STsubRaw = STsubRaw + SsubRaw;
        %     imshow(STmeanRaw);
    end
    STmeanRaw = STsubRaw / sam_num;
    imwrite(STmeanRaw, ['STA_' D{end} '_' method '.tiff']);
    imwrite(STmeanRaw, ['STA_' D{end} '_' method '.png']);
elseif strcmp(method, 'B') ==1
    % each WxW patch can be transformed to a R/G/B pixel
    STsubRaw = zeros(hm, wm, chm, 'uint16');
    for i = 1:sam_num
        S = regexp(im_dir(i).name, '\.', 'split');
        Raw = imread([Original_image_dir '/' S{1} '.tiff']);
        SsubRaw = spatialaverageB(Raw, W);
        STsubRaw = STsubRaw + SsubRaw;
        %     imshow(STmeanRaw);
    end
    STmeanRaw = STsubRaw / sam_num;
    imwrite(STmeanRaw, ['STA_' D{end} '_' method '.tiff']);
    imwrite(STmeanRaw, ['STA_' D{end} '_' method '.png']);
end