clear;
%% mean of raw images
Original_image_dir = '20161228mean/';
fpath = fullfile(Original_image_dir, '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);
D = regexp(Original_image_dir, '/', 'split');

%% 500vsAll
% read six mean/GT images
meansRGB500 = imread([Original_image_dir 'meansRGB500_ARW2TIF_TIF2PNG.png']);
meansRGBAll = imread([Original_image_dir 'meansRGBAll_ARW2TIF_TIF2PNG.png']);
meanRAW500 = imread([Original_image_dir  'meanRAW500_ARW2TIF_TIF2PNG.png']);
meanRAWAll = imread([Original_image_dir 'meanRAWAll_ARW2TIF_TIF2PNG.png']);
RAWGT500 = imread([Original_image_dir 'RawGT500_ARW2TIF_TIF2PNG.png']);
RAWGTAll = imread([Original_image_dir 'RawGTAll_ARW2TIF_TIF2PNG.png']);

for scale = [0.5 0.25]
    gf = fspecial('gaussian', [15 15], 16);
    meansRGB500 = imresize(imfilter(meansRGB500, gf, 'same'), scale);
    meansRGBAll = imresize(imfilter(meansRGBAll, gf, 'same'), scale);
    meanRAW500 = imresize(imfilter(meanRAW500, gf, 'same'), scale);
    meanRAWAll = imresize(imfilter(meanRAWAll, gf, 'same'), scale);
    RAWGT500 = imresize(imfilter(RAWGT500, gf, 'same'), scale);
    RAWGTAll = imresize(imfilter(RAWGTAll, gf, 'same'), scale);
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
    
    savename = ['PSNRSSIM_meansRGB_meanRAW_RAWGT_500vsAll_' D{1}(1:8) '_' num2str(scale) '.mat'];
    save(savename, 'PSNR_meansRGB500_meansRGBAll', 'SSIM_meansRGB500_meansRGBAll', ...
        'PSNR_meansRGB500_meanRAWAll', 'SSIM_meansRGB500_meanRAWAll',...
        'PSNR_meansRGB500_RAWGTAll', 'SSIM_meansRGB500_RAWGTAll', ...
        'PSNR_meanRAW500_meansRGBAll', 'SSIM_meanRAW500_meansRGBAll', ...
        'PSNR_meanRAW500_meanRAWAll', 'SSIM_meanRAW500_meanRAWAll',...
        'PSNR_meanRAW500_RAWGTAll', 'SSIM_meanRAW500_RAWGTAll',...
        'PSNR_RAWGT500_meansRGBAll', 'SSIM_RAWGT500_meansRGBAll', ...
        'PSNR_RAWGT500_meanRAWAll', 'SSIM_RAWGT500_meanRAWAll',...
        'PSNR_RAWGT500_RAWGTAll', 'SSIM_RAWGT500_RAWGTAll');
end