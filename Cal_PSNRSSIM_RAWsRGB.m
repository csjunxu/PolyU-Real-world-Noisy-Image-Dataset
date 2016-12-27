clear;
%% mean of raw images
Original_image_dir = '20161226_ISO3200_5000/';
fpath = fullfile(Original_image_dir, '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);
meansRGBAll = imread('20161226mean_ISO3200_5000/meansRGBAll_ARW2TIF_TIF2PNG.png');
meanRAWAll = imread('20161226mean_ISO3200_5000/meanRAWAll_ARW2TIF_TIF2PNG.png');
RAWGTAll = imread('20161226mean_ISO3200_5000/RawGTAll_ARW2TIF_TIF2PNG.png');
fprintf('The PSNR/SSIM of meansRGBAll/meanRAWAll are %2.4f/%2.4f. \n', csnr( meansRGBAll,meanRAWAll, 0, 0 ), cal_ssim( meansRGBAll, meanRAWAll, 0, 0 ));
fprintf('The PSNR/SSIM of meansRGBAll/RAWGTAll are %2.4f/%2.4f. \n', csnr( meansRGBAll,RAWGTAll, 0, 0 ), cal_ssim( meansRGBAll, RAWGTAll, 0, 0 ));
PSNR_meansRGBAll = [];
SSIM_meansRGBAll = [];
PSNR_meanRAWAll = [];
SSIM_meanRAWAll = [];
PSNR_RAWGTAll = [];
SSIM_RAWGTAll = [];
PSNR_meansRGB500 = [];
SSIM_meansRGB500 = [];
PSNR_meanRAW500 = [];
SSIM_meanRAW500 = [];
PSNR_RAWGT500 = [];
SSIM_RAWGT500 = [];
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
    if i <= min(500,im_num)
        PSNR_meansRGB500 = PSNR_meansRGBAll;
        SSIM_meansRGB500 = SSIM_meansRGBAll;
        PSNR_meanRAW500 = PSNR_meanRAWAll;
        SSIM_meanRAW500 = SSIM_meanRAWAll;
        PSNR_RAWGT500 = PSNR_RAWGTAll;
        SSIM_RAWGT500 = SSIM_RAWGTAll;
    end
    if i == min(500,im_num)
        mPSNR_meansRGB500 = mean(PSNR_meansRGB500);
        mSSIM_meansRGB500 = mean(SSIM_meansRGB500);
        mPSNR_meanRAW500 = mean(PSNR_meanRAW500);
        mSSIM_meanRAW500 = mean(SSIM_meanRAW500);
        mPSNR_RAWGT500 = mean(PSNR_RAWGT500);
        mSSIM_RAWGT500 = mean(SSIM_RAWGT500);
        savename = ['PSNRSSIM_meansRGB500_meanRAW500_RAWGT500_20161226_ISO3200.mat'];
        save(savename, 'mPSNR_meansRGB500','mSSIM_meansRGB500','PSNR_meansRGB500','SSIM_meansRGB500', ...
            'mPSNR_meanRAW500', 'mSSIM_meanRAW500', 'PSNR_meanRAW500', 'SSIM_meanRAW500',...
            'mPSNR_RAWGT500', 'mSSIM_RAWGT500', 'PSNR_RAWGT500', 'SSIM_RAWGT500');
    end
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



