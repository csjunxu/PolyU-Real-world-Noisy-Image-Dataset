clear;
%% mean of raw images
Original_image_dir = '20161221/';
fpath = fullfile(Original_image_dir, '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);
RAW_GT = imread('20161221mean/RawGT_ARW2TIF_TIF2PNG.png');
sRGB_GT = imread('20161221mean/meansRGB_ARW2TIF_TIF2PNG.png');
fprintf('The PSNR/SSIM of RAW_GT and meansRGB are %2.4f/%2.4f. \n', csnr( sRGB_GT,RAW_GT, 0, 0 ), cal_ssim( sRGB_GT, sRGB_GT, 0, 0 ));
PSNR_raw = [];
SSIM_raw = [];
PSNR_sRGB = [];
SSIM_sRGB = [];
for i = 1:im_num
    %% read the tiff image
    IMin = imread(fullfile(Original_image_dir, im_dir(i).name));
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    fprintf('Processing %s. \n', rawname);
    PSNR_raw = [PSNR_raw csnr( IMin,RAW_GT, 0, 0 )];
    SSIM_raw = [SSIM_raw cal_ssim( IMin, RAW_GT, 0, 0 )];
    PSNR_sRGB = [PSNR_sRGB csnr( IMin,sRGB_GT, 0, 0 )];
    SSIM_sRGB = [SSIM_sRGB cal_ssim( IMin, sRGB_GT, 0, 0 )];
    fprintf('The PSNR_raw = %2.4f, SSIM_raw = %2.4f. \n', PSNR_raw(end), SSIM_raw(end));
    fprintf('The PSNR_sRGB = %2.4f, SSIM_sRGB = %2.4f. \n', PSNR_sRGB(end), SSIM_sRGB(end));
end
mPSNR_raw = mean(PSNR_raw);
mSSIM_raw = mean(SSIM_raw);
mPSNR_sRGB = mean(PSNR_sRGB);
mSSIM_sRGB = mean(SSIM_sRGB);
savename = ['PSNRSSIM_RawGT_vs_meansRGB_20161221_ISO3200.mat'];
save(savename, 'mPSNR_raw', 'mSSIM_raw', 'PSNR_raw', 'SSIM_raw', 'mPSNR_sRGB', 'mSSIM_sRGB', 'PSNR_sRGB', 'SSIM_sRGB');

fpath = fullfile(Original_image_dir, '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);
RAW_GT = imread('20161221mean/meanRAW_ARW2TIF_TIF2PNG.png');
sRGB_GT = imread('20161221mean/meansRGB_ARW2TIF_TIF2PNG.png');
fprintf('The PSNR/SSIM of meanRAW and meansRGB are %2.4f/%2.4f. \n', csnr( sRGB_GT,RAW_GT, 0, 0 ), cal_ssim( sRGB_GT, sRGB_GT, 0, 0 ));
PSNR_raw = [];
SSIM_raw = [];
PSNR_sRGB = [];
SSIM_sRGB = [];
for i = 1:im_num
    %% read the tiff image
    IMin = imread(fullfile(Original_image_dir, im_dir(i).name));
    S = regexp(im_dir(i).name, '\.', 'split');
    rawname = S{1};
    fprintf('Processing %s. \n', rawname);
    PSNR_raw = [PSNR_raw csnr( IMin,RAW_GT, 0, 0 )];
    SSIM_raw = [SSIM_raw cal_ssim( IMin, RAW_GT, 0, 0 )];
    PSNR_sRGB = [PSNR_sRGB csnr( IMin,sRGB_GT, 0, 0 )];
    SSIM_sRGB = [SSIM_sRGB cal_ssim( IMin, sRGB_GT, 0, 0 )];
    fprintf('The PSNR_raw = %2.4f, SSIM_raw = %2.4f. \n', PSNR_raw(end), SSIM_raw(end));
    fprintf('The PSNR_sRGB = %2.4f, SSIM_sRGB = %2.4f. \n', PSNR_sRGB(end), SSIM_sRGB(end));
end
mPSNR_raw = mean(PSNR_raw);
mSSIM_raw = mean(SSIM_raw);
mPSNR_sRGB = mean(PSNR_sRGB);
mSSIM_sRGB = mean(SSIM_sRGB);
savename = ['PSNRSSIM_meanRAW_vs_meansRGB_20161221_ISO3200.mat'];
save(savename, 'mPSNR_raw', 'mSSIM_raw', 'PSNR_raw', 'SSIM_raw', 'mPSNR_sRGB', 'mSSIM_sRGB', 'PSNR_sRGB', 'SSIM_sRGB');





