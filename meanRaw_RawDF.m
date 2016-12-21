%% mean Scene minus mean DF
% 128 is the reset value for Sony A7 II 
reset = 128;
meanRaw = imread('meanRAW_ARW2TIF.tiff');
meanDF = imread('meanDF_ARW2TIF.tiff');
meanGT = meanRaw - meanDF + reset; 
imwrite(meanGT,'meanGT_ARW2TIF.tiff');