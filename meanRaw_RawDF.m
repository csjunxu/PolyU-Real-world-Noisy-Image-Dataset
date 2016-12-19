%% mean Scene minus mean DF
meanRaw = imread('mean_RAW_ARW2TIF.tiff');
meanDF = imread('mean_DF_ARW2TIF.tiff');
meanGT = meanRaw - meanDF;
imwrite(meanGT,'mean_GT_ARW2TIF.tiff');