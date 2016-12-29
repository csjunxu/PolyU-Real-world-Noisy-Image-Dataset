%% mean Scene minus mean DF
% 128 is the reset value for Sony A7 II 
Original_image_dir = '20161228mean/';
reset = 128;
%% ALL
meanRawAll = imread([Original_image_dir 'meanRAWAll_ARW2TIF.tiff']);
meanDFTIFAll = imread([Original_image_dir 'meanDFAll_ARW2TIF.tiff']);
meanGTAll = meanRawAll - meanDFTIFAll + reset; 
imwrite(meanGTAll,[Original_image_dir 'RawGTAll_ARW2TIF.tiff']);
% meanDFpgmAll = imread([Original_image_dir 'meanDFAll_ARW2pgm.pgm']);
% meanGTAll = meanRawAll - meanDFpgmAll + reset; 
% imwrite(meanGTAll,[Original_image_dir 'RawGTAll_ARW2pgm.tiff']);

%% 500
meanRaw500 = imread([Original_image_dir 'meanRAW500_ARW2TIF.tiff']);
meanDFTIF500 = imread([Original_image_dir 'meanDF500_ARW2TIF.tiff']);
meanGT500 = meanRaw500 - meanDFTIF500 + reset; 
imwrite(meanGT500,[Original_image_dir 'RawGT500_ARW2TIF.tiff']);
% meanDFpgm500 = imread([Original_image_dir 'meanDF500_ARW2pgm.pgm']);
% meanGT500 = meanRaw500 - meanDFpgm500 + reset; 
% imwrite(meanGT500,[Original_image_dir 'RawGT500_ARW2pgm.tiff']);