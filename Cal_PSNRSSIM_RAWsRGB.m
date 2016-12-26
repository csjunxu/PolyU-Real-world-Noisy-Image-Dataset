clear;
%% mean of raw images
Original_image_dir = '20161226_ISO3200_5000/';
fpath = fullfile(Original_image_dir, '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);
meanRAWAll = imread('20161226mean_ISO3200_5000/meanRAWAll_ARW2TIF_TIF2PNG.png');
RAWGTAll = imread('20161226mean_ISO3200_5000/RawGTAll_ARW2TIF_TIF2PNG.png');
meansRGBAll = imread('20161226mean_ISO3200_5000/meansRGB_ARW2TIF_TIF2PNG.png');
fprintf('The PSNR/SSIM of meanRAW/meansRGB are %2.4f/%2.4f. \n', csnr( meansRGBAll,meanRAWAll, 0, 0 ), cal_ssim( meansRGBAll, meanRAWAll, 0, 0 ));
fprintf('The PSNR/SSIM of RAW_GT/meansRGB are %2.4f/%2.4f. \n', csnr( meansRGBAll,RAWGTAll, 0, 0 ), cal_ssim( meansRGBAll, RAWGTAll, 0, 0 ));
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
    PSNR_meansRGBAll = [PSNR_meansRGBAll csnr( IMin,meansRGBAll, 0, 0 )];
    SSIM_meansRGBAll = [SSIM_meansRGBAll cal_ssim( IMin, meansRGBAll, 0, 0 )];
    PSNR_meanRAWAll = [PSNR_meanRAWAll csnr( IMin,meanRAWAll, 0, 0 )];
    SSIM_meanRAWAll = [SSIM_meanRAWAll cal_ssim( IMin, meanRAWAll, 0, 0 )];
    PSNR_RAWGTAll = [PSNR_RAWGTAll csnr( IMin,RAWGTAll, 0, 0 )];
    SSIM_RAWGTAll = [SSIM_RAWGTAll cal_ssim( IMin, RAWGTAll, 0, 0 )];
    fprintf('The PSNR/SSIM of  meansRGB are %2.4f/%2.4f. \n', PSNR_meansRGBAll(end), SSIM_meansRGBAll(end));
    fprintf('The PSNR/SSIM of meanRAW are %2.4f/%2.4f. \n', PSNR_meanRAWAll(end), SSIM_meanRAWAll(end));
    fprintf('The PSNR/SSIM of RAWGT are %2.4f/%2.4f. \n', PSNR_RAWGTAll(end), SSIM_RAWGTAll(end));
end
mPSNR_meansRGBAll = mean(PSNR_meansRGBAll);
mSSIM_meansRGBAll = mean(SSIM_meansRGBAll);
mPSNR_meanRAWAll = mean(PSNR_meanRAWAll);
mSSIM_meanRAWAll = mean(SSIM_meanRAWAll);
mPSNR_RAWGTAll = mean(PSNR_RAWGTAll);
mSSIM_RAWGTAll = mean(SSIM_RAWGTAll);
savename = ['PSNRSSIM_meansRGBAll_meanRAWAll_RAWGTAll_20161226_ISO3200.mat'];
save(savename, 'mPSNR_meansRGBAll','mSSIM_meansRGBAll','PSNR_meansRGBAll','SSIM_meansRGBAll', ...
    'mPSNR_meanRAWAll', 'mSSIM_meanRAWAll', 'PSNR_meanRAWAll', 'SSIM_meanRAWAll',...
    'mPSNR_RAWGTAll', 'mSSIM_RAWGTAll', 'PSNR_RAWGTAll', 'SSIM_RAWGTAll');



