clear;
%% mean of raw images
Original_image_dir = '20161230mean/';
D = regexp(Original_image_dir, '/', 'split');

%% 500vsAll
% read six mean/GT images
meansRGB500 = imread([Original_image_dir 'meansRGB500_ARW2TIF_TIF2PNG.png']);
meansRGBAll = imread([Original_image_dir 'meansRGBAll_ARW2TIF_TIF2PNG.png']);
meanRAW500 = imread([Original_image_dir  'meanRAW500_ARW2TIF_TIF2PNG.png']);
meanRAWAll = imread([Original_image_dir 'meanRAWAll_ARW2TIF_TIF2PNG.png']);
RAWGT500 = imread([Original_image_dir 'RawGT500_ARW2TIF_TIF2PNG.png']);
RAWGTAll = imread([Original_image_dir 'RawGTAll_ARW2TIF_TIF2PNG.png']);
% 3 vs 3

% meansRGB500 vs meansRGBAll
PSNR_meansRGB500_meansRGBAll = csnr( meansRGB500, meansRGBAll, 0, 0 );
SSIM_meansRGB500_meansRGBAll = cal_ssim( meansRGB500, meansRGBAll, 0, 0 );
fprintf('The PSNR/SSIM of meansRGB500 over meansRGBAll are %2.4f/%2.4f. \n', PSNR_meansRGB500_meansRGBAll, SSIM_meansRGB500_meansRGBAll);
% meansRGB500 vs meanRAWAll
PSNR_meansRGB500_meanRAWAll = csnr( meansRGB500, meanRAWAll, 0, 0 );
SSIM_meansRGB500_meanRAWAll = cal_ssim( meansRGB500, meanRAWAll, 0, 0 );
fprintf('The PSNR/SSIM of meansRGB500 over meanRAWAll are %2.4f/%2.4f. \n', PSNR_meansRGB500_meanRAWAll, SSIM_meansRGB500_meanRAWAll);
% meansRGB500 vs RAWGTAll
PSNR_meansRGB500_RAWGTAll = csnr( meansRGB500, RAWGTAll, 0, 0 );
SSIM_meansRGB500_RAWGTAll = cal_ssim( meansRGB500, RAWGTAll, 0, 0 );
fprintf('The PSNR/SSIM of meansRGB500 over RAWGTAll are %2.4f/%2.4f. \n', PSNR_meansRGB500_RAWGTAll, SSIM_meansRGB500_RAWGTAll);

% meanRAW500 vs meansRGBAll
PSNR_meanRAW500_meansRGBAll = csnr( meanRAW500,meansRGBAll, 0, 0 );
SSIM_meanRAW500_meansRGBAll = cal_ssim( meanRAW500, meansRGBAll, 0, 0 );
fprintf('The PSNR/SSIM of meanRAW500 over meansRGBAll are %2.4f/%2.4f. \n', PSNR_meanRAW500_meansRGBAll, SSIM_meanRAW500_meansRGBAll);
% meanRAW500 vs meanRAWAll
PSNR_meanRAW500_meanRAWAll = csnr( meanRAW500,meanRAWAll, 0, 0 );
SSIM_meanRAW500_meanRAWAll = cal_ssim( meanRAW500, meanRAWAll, 0, 0 );
fprintf('The PSNR/SSIM of meanRAW500 over meanRAWAll are %2.4f/%2.4f. \n', PSNR_meanRAW500_meanRAWAll, SSIM_meanRAW500_meanRAWAll);
% meanRAW500 vs RAWGTAll
PSNR_meanRAW500_RAWGTAll = csnr( meanRAW500,RAWGTAll, 0, 0 );
SSIM_meanRAW500_RAWGTAll = cal_ssim( meanRAW500, RAWGTAll, 0, 0 );
fprintf('The PSNR/SSIM of meanRAW500 over RAWGTAll are %2.4f/%2.4f. \n', PSNR_meanRAW500_RAWGTAll, SSIM_meanRAW500_RAWGTAll);

% RAWGT500 vs meansRGBAll
PSNR_RAWGT500_meansRGBAll = csnr( RAWGT500,meansRGBAll, 0, 0 );
SSIM_RAWGT500_meansRGBAll = cal_ssim( RAWGT500, meansRGBAll, 0, 0 );
fprintf('The PSNR/SSIM of RAWGT500 over meansRGBAll are %2.4f/%2.4f. \n', PSNR_RAWGT500_meansRGBAll, SSIM_RAWGT500_meansRGBAll);
% RAWGT500 vs meanRAWAll
PSNR_RAWGT500_meanRAWAll = csnr( RAWGT500,meanRAWAll, 0, 0 );
SSIM_RAWGT500_meanRAWAll = cal_ssim( RAWGT500, meanRAWAll, 0, 0 );
fprintf('The PSNR/SSIM of RAWGT500 over meanRAWAll are %2.4f/%2.4f. \n', PSNR_RAWGT500_meanRAWAll, SSIM_RAWGT500_meanRAWAll);
% RAWGT500 vs RAWGTAll
PSNR_RAWGT500_RAWGTAll = csnr( RAWGT500,RAWGTAll, 0, 0 );
SSIM_RAWGT500_RAWGTAll = cal_ssim( RAWGT500, RAWGTAll, 0, 0 );
fprintf('The PSNR/SSIM of RAWGT500 over RAWGTAll are %2.4f/%2.4f. \n', PSNR_RAWGT500_RAWGTAll, SSIM_RAWGT500_RAWGTAll);

savename = ['PSNRSSIM_meansRGB_meanRAW_RAWGT_500vsAll_' D{1}(1:8) '.mat'];
save(savename, 'PSNR_meansRGB500_meansRGBAll', 'SSIM_meansRGB500_meansRGBAll', ...
    'PSNR_meansRGB500_meanRAWAll', 'SSIM_meansRGB500_meanRAWAll',...
    'PSNR_meansRGB500_RAWGTAll', 'SSIM_meansRGB500_RAWGTAll', ...
    'PSNR_meanRAW500_meansRGBAll', 'SSIM_meanRAW500_meansRGBAll', ...
    'PSNR_meanRAW500_meanRAWAll', 'SSIM_meanRAW500_meanRAWAll',...
    'PSNR_meanRAW500_RAWGTAll', 'SSIM_meanRAW500_RAWGTAll',...
    'PSNR_RAWGT500_meansRGBAll', 'SSIM_RAWGT500_meansRGBAll', ...
    'PSNR_RAWGT500_meanRAWAll', 'SSIM_RAWGT500_meanRAWAll',...
    'PSNR_RAWGT500_RAWGTAll', 'SSIM_RAWGT500_RAWGTAll');

%% mean of raw images
Original_meanimage_dir = '20161230mean/';
Original_image_dir = '20161230/';
fpath = fullfile(Original_image_dir, '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);
D = regexp(Original_image_dir, '/', 'split');
%% RAWsRGB
meansRGB500 = imread([Original_meanimage_dir 'meansRGB500_ARW2TIF_TIF2PNG.png']);
meanRAW500 = imread([Original_meanimage_dir 'meanRAW500_ARW2TIF_TIF2PNG.png']);
RAWGT500 = imread([Original_meanimage_dir 'RawGT500_ARW2TIF_TIF2PNG.png']);
meansRGBAll = imread([Original_meanimage_dir 'meansRGBAll_ARW2TIF_TIF2PNG.png']);
meanRAWAll = imread([Original_meanimage_dir 'meanRAWAll_ARW2TIF_TIF2PNG.png']);
RAWGTAll = imread([Original_meanimage_dir 'RawGTAll_ARW2TIF_TIF2PNG.png']);
PSNR_meansRGB500 = [];
SSIM_meansRGB500 = [];
PSNR_meanRAW500 = [];
SSIM_meanRAW500 = [];
PSNR_RAWGT500 = [];
SSIM_RAWGT500 = [];
PSNR_meansRGBAll = [];
SSIM_meansRGBAll = [];
PSNR_meanRAWAll = [];
SSIM_meanRAWAll = [];
PSNR_RAWGTAll = [];
SSIM_RAWGTAll = [];
for i = 1:im_num
    %% read the tiff image
    IMin = imread(fullfile(Original_image_dir, im_dir(i).name));
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    fprintf('Processing %s. \n', rawname);
    if i <= min(500,im_num)
        PSNR_meansRGB500 = [PSNR_meansRGB500 csnr( IMin,meansRGB500, 0, 0 )];
        SSIM_meansRGB500 = [SSIM_meansRGB500 cal_ssim( IMin, meansRGB500, 0, 0 )];
        PSNR_meanRAW500 = [PSNR_meanRAW500 csnr( IMin,meanRAW500, 0, 0 )];
        SSIM_meanRAW500 = [SSIM_meanRAW500 cal_ssim( IMin, meanRAW500, 0, 0 )];
        PSNR_RAWGT500 = [PSNR_RAWGT500 csnr( IMin,RAWGT500, 0, 0 )];
        SSIM_RAWGT500 = [SSIM_RAWGT500 cal_ssim( IMin, RAWGT500, 0, 0 )];
        fprintf('The PSNR/SSIM over  meansRGB500 are %2.4f/%2.4f. \n', PSNR_meansRGB500(end), SSIM_meansRGB500(end));
        fprintf('The PSNR/SSIM over meanRAW500 are %2.4f/%2.4f. \n', PSNR_meanRAW500(end), SSIM_meanRAW500(end));
        fprintf('The PSNR/SSIM over RAWGT500 are %2.4f/%2.4f. \n', PSNR_RAWGT500(end), SSIM_RAWGT500(end));
    end
    PSNR_meansRGBAll = [PSNR_meansRGBAll csnr( IMin,meansRGBAll, 0, 0 )];
    SSIM_meansRGBAll = [SSIM_meansRGBAll cal_ssim( IMin, meansRGBAll, 0, 0 )];
    PSNR_meanRAWAll = [PSNR_meanRAWAll csnr( IMin,meanRAWAll, 0, 0 )];
    SSIM_meanRAWAll = [SSIM_meanRAWAll cal_ssim( IMin, meanRAWAll, 0, 0 )];
    PSNR_RAWGTAll = [PSNR_RAWGTAll csnr( IMin,RAWGTAll, 0, 0 )];
    SSIM_RAWGTAll = [SSIM_RAWGTAll cal_ssim( IMin, RAWGTAll, 0, 0 )];
    fprintf('The PSNR/SSIM over  meansRGBAll are %2.4f/%2.4f. \n', PSNR_meansRGBAll(end), SSIM_meansRGBAll(end));
    fprintf('The PSNR/SSIM over meanRAWAll are %2.4f/%2.4f. \n', PSNR_meanRAWAll(end), SSIM_meanRAWAll(end));
    fprintf('The PSNR/SSIM over RAWGTAll are %2.4f/%2.4f. \n', PSNR_RAWGTAll(end), SSIM_RAWGTAll(end));
end
mPSNR_meansRGB500 = mean(PSNR_meansRGB500);
mSSIM_meansRGB500 = mean(SSIM_meansRGB500);
mPSNR_meanRAW500 = mean(PSNR_meanRAW500);
mSSIM_meanRAW500 = mean(SSIM_meanRAW500);
mPSNR_RAWGT500 = mean(PSNR_RAWGT500);
mSSIM_RAWGT500 = mean(SSIM_RAWGT500);
savename = ['PSNRSSIM_meansRGB500_meanRAW500_RAWGT500_' D{1}(1:8) '.mat'];
save(savename, 'mPSNR_meansRGB500','mSSIM_meansRGB500','PSNR_meansRGB500','SSIM_meansRGB500', ...
    'mPSNR_meanRAW500', 'mSSIM_meanRAW500', 'PSNR_meanRAW500', 'SSIM_meanRAW500',...
    'mPSNR_RAWGT500', 'mSSIM_RAWGT500', 'PSNR_RAWGT500', 'SSIM_RAWGT500');
mPSNR_meansRGBAll = mean(PSNR_meansRGBAll);
mSSIM_meansRGBAll = mean(SSIM_meansRGBAll);
mPSNR_meanRAWAll = mean(PSNR_meanRAWAll);
mSSIM_meanRAWAll = mean(SSIM_meanRAWAll);
mPSNR_RAWGTAll = mean(PSNR_RAWGTAll);
mSSIM_RAWGTAll = mean(SSIM_RAWGTAll);
savename = ['PSNRSSIM_meansRGBAll_meanRAWAll_RAWGTAll_' D{1}(1:8) '.mat'];
save(savename, 'mPSNR_meansRGBAll','mSSIM_meansRGBAll','PSNR_meansRGBAll','SSIM_meansRGBAll', ...
    'mPSNR_meanRAWAll', 'mSSIM_meanRAWAll', 'PSNR_meanRAWAll', 'SSIM_meanRAWAll',...
    'mPSNR_RAWGTAll', 'mSSIM_RAWGTAll', 'PSNR_RAWGTAll', 'SSIM_RAWGTAll');


