clear;
%% mean of raw images
Original_image_dir = '20161226mean_ISO3200_5000/';
fpath = fullfile(Original_image_dir, '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);
%% read six mean/GT images
meansRGB500 = imread([Original_image_dir 'meansRGB500_ARW2TIF_TIF2PNG.png']);
meansRGBAll = imread([Original_image_dir 'meansRGBAll_ARW2TIF_TIF2PNG.png']);
meanRAW500 = imread('20161226mean_ISO3200_5000/meanRAW500_ARW2TIF_TIF2PNG.png');
meanRAWAll = imread('20161226mean_ISO3200_5000/meanRAWAll_ARW2TIF_TIF2PNG.png');
RAWGT500 = imread('20161226mean_ISO3200_5000/RawGT500_ARW2TIF_TIF2PNG.png');
RAWGTAll = imread('20161226mean_ISO3200_5000/RawGTAll_ARW2TIF_TIF2PNG.png');
%% 3 vs 3
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
fprintf('The PSNR/SSIM of meanRAW500 over meanRAWAll are %2.4f/%2.4f. \n', PSNR_meanRAW500_RAWGTAll, SSIM_meanRAW500_RAWGTAll);

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
fprintf('The PSNR/SSIM of meanRAW500 over meanRAWAll are %2.4f/%2.4f. \n', PSNR_meanRAW500_RAWGTAll, SSIM_meanRAW500_RAWGTAll);
% 
PSNR_meansRGB = csnr( IMin,meansRGB, 0, 0 );
SSIM_meansRGB = cal_ssim( IMin, meansRGB, 0, 0 );
fprintf('The PSNR/SSIM of meanRAW500 over meanRAWAll are %2.4f/%2.4f. \n', PSNR_meanRAW500_meanRAWAll, SSIM_meanRAW500_meanRAWAll);
fprintf('The PSNR/SSIM of RAWGT are %2.4f/%2.4f. \n', PSNR_RAWGT, SSIM_RAWGT);
fprintf('The PSNR/SSIM of  meansRGB are %2.4f/%2.4f. \n', PSNR_meansRGB, SSIM_meansRGB);
savename = ['PSNRSSIM_meanRAW_RAWGT_meansRGB_20161226mean_ISO3200_500_5000.mat'];
save(savename, 'PSNR_meanRAW500_meanRAWAll', 'SSIM_meanRAW500_meanRAWAll', ...
    'PSNR_meanRAW', 'SSIM_meanRAW',...
    'mPSNR_RAWGT', 'mSSIM_RAWGT', 'PSNR_RAWGT', 'SSIM_RAWGT',...
    'mPSNR_meansRGB','mSSIM_meansRGB','PSNR_meansRGB','SSIM_meansRGB');



