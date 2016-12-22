%% mean Scene minus mean DF
% 128 is the reset value for Sony A7 II 
Original_image_dir = '20161221mean/';
reset = 128;
meanRaw = imread([Original_image_dir 'meanRAW_ARW2TIF.tiff']);
meanDFTIF = imread([Original_image_dir 'meanDF_ARW2TIF.tiff']);
meanGT = meanRaw - meanDFTIF + reset; 
imwrite(meanGT,[Original_image_dir 'RawGT_ARW2TIF.tiff']);
meanDFpgm = imread([Original_image_dir 'meanDF_ARW2pgm.pgm']);
meanGT = meanRaw - meanDFpgm + reset; 
imwrite(meanGT,[Original_image_dir 'RawGT_ARW2pgm.tiff']);