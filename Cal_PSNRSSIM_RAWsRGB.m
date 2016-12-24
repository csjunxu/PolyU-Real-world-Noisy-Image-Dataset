clear;
%% mean of raw images
Original_image_dir = '20161223/';
fpath = fullfile(Original_image_dir, '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);
meanRAW = imread('20161223mean/meanRAW_ARW2TIF_TIF2PNG.png');
RAWGT = imread('20161223mean/RawGT_ARW2TIF_TIF2PNG.png');
meansRGB = imread('20161223mean/meansRGB_ARW2TIF_TIF2PNG.png');
fprintf('The PSNR/SSIM of meanRAW and meansRGB are %2.4f/%2.4f. \n', csnr( meansRGB,meanRAW, 0, 0 ), cal_ssim( meansRGB, meanRAW, 0, 0 ));
fprintf('The PSNR/SSIM of RAW_GT and meansRGB are %2.4f/%2.4f. \n', csnr( meansRGB,RAWGT, 0, 0 ), cal_ssim( meansRGB, RAWGT, 0, 0 ));
PSNR_meanRAW = [];
SSIM_meanRAW = [];
PSNR_RAWGT = [];
SSIM_RAWGT = [];
PSNR_meansRGB = [];
SSIM_meansRGB = [];
for i = 1:im_num
    %% read the tiff image
    IMin = imread(fullfile(Original_image_dir, im_dir(i).name));
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    fprintf('Processing %s. \n', rawname);
    PSNR_meanRAW = [PSNR_meanRAW csnr( IMin,meanRAW, 0, 0 )];
    SSIM_meanRAW = [SSIM_meanRAW cal_ssim( IMin, meanRAW, 0, 0 )];
    PSNR_RAWGT = [PSNR_RAWGT csnr( IMin,RAWGT, 0, 0 )];
    SSIM_RAWGT = [SSIM_RAWGT cal_ssim( IMin, RAWGT, 0, 0 )];
    PSNR_meansRGB = [PSNR_meansRGB csnr( IMin,meansRGB, 0, 0 )];
    SSIM_meansRGB = [SSIM_meansRGB cal_ssim( IMin, meansRGB, 0, 0 )];
    fprintf('The PSNR_meanRAW = %2.4f, SSIM_meanRAW = %2.4f. \n', PSNR_meanRAW(end), SSIM_meanRAW(end));
    fprintf('The PSNR_RAWGT = %2.4f, SSIM_RAWGT = %2.4f. \n', PSNR_RAWGT(end), SSIM_RAWGT(end));
    fprintf('The PSNR_sRGB = %2.4f, SSIM_sRGB = %2.4f. \n', PSNR_meansRGB(end), SSIM_meansRGB(end));
end
mPSNR_meanRAW = mean(PSNR_meanRAW);
mSSIM_meanRAW = mean(SSIM_meanRAW);
mPSNR_RAWGT = mean(PSNR_RAWGT);
mSSIM_RAWGT = mean(SSIM_RAWGT);
mPSNR_meansRGB = mean(PSNR_meansRGB);
mSSIM_meansRGB = mean(SSIM_meansRGB);
savename = ['PSNRSSIM_meanRAW_RAWGT_meansRGB_20161223_ISO1600.mat'];
save(savename, 'mPSNR_meanRAW', 'mSSIM_meanRAW', 'PSNR_meanRAW', 'SSIM_meanRAW',...
    'mPSNR_RAWGT', 'mSSIM_RAWGT', 'PSNR_RAWGT', 'SSIM_RAWGT',...
    'mPSNR_meansRGB','mSSIM_meansRGB','PSNR_meansRGB','SSIM_meansRGB');



