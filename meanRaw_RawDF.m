%% mean Scene minus mean DF
% 128 is the reset value for Sony A7 II 
reset = 128;
meanRaw = imread('mean_RAW_ARW2TIF.tiff');
meanDF = imread('mean_DF_ARW2TIF.tiff');
meanGT = meanRaw - meanDF + reset; 
imwrite(meanGT,'mean_GT_ARW2TIF.tiff');