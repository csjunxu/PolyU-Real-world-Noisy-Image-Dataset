% given paired noisy and clean images with high resolutions, this function crops these
% images into smaller parts with paired regions
clear;
Original_image_dir  =    'C:/Users/csjunxu/Desktop/Projects/RID_Dataset/20170123DJI/';
% Get a list of all files and folders in this folder.
files = dir(Original_image_dir);
% Get a logical vector that tells which is a directory.
dirFlags = [files.isdir];
% Extract only those that are directories.
subdir = files(dirFlags);
% Print folder names to command window.
for k = 1 : length(subdir)
    if length(strfind(subdir(k).name, 'mean')) >= 1 || strcmp(subdir(k).name, '.') == 1 || strcmp(subdir(k).name, '..') == 1
        continue;
    end
    fprintf('Sub folder #%d = %s\n', k, subdir(k).name);
    sRGB_dir       =  fullfile(Original_image_dir, subdir(k).name);
    mean_dir       =  fullfile(Original_image_dir, [subdir(k).name 'mean']);
    GTpath = fullfile(mean_dir, '*.JPG');
    GT_dir  = dir(GTpath);
    I =  im2double( imread(fullfile(mean_dir, GT_dir(1).name)) );
    GT_D = regexp(mean_dir, '/', 'split');
    
    fpath = fullfile(sRGB_dir, '*.JPG');
    nim_dir  = dir(fpath);
    nim_num = length(nim_dir);
    nim_D = regexp(sRGB_dir, '/', 'split');
    
    % set the image size to 512x512
    height = 512;
    width = 512;
    list = randi(nim_num, [1 20]);
    for i = 1:length(list)
        nI =  im2double( imread(fullfile(sRGB_dir, nim_dir(list(i)).name)) );
        S = regexp(nim_dir(list(i)).name, '\.', 'split');
        fprintf('The image is %s.\n', S{1});
        [h, w, ch]=size(nI);
        %% 1. randomly generate position index
        hi = randi( [min(floor(h/4), h - height + 1), floor(3/4 * h)] );
        wi = randi( [min(floor(w/4), w - width + 1), floor(3/4 * w)] );
        %% 2. crop paired images
        cropI = I( hi : hi + height - 1, wi : wi + width - 1, : );
        cropnI = nI( hi : hi + height - 1, wi : wi + width - 1, : );
        fprintf('The PSNR = %2.4f, SSIM = %2.4f\n', csnr( cropnI*255, cropI*255, 0, 0 ), cal_ssim( cropnI*255, cropI*255, 0, 0 ));
         
        imshow(cropnI);
        %% 3. write images
        write_mean_dir = 'C:/Users/csjunxu/Desktop/CVPR2017/DJI_Results/Real_MeanImage/';
        write_sRGB_dir = 'C:/Users/csjunxu/Desktop/CVPR2017/DJI_Results/Real_NoisyImage/';
        if ~isdir(write_mean_dir)
            mkdir(write_mean_dir)
        end
        if ~isdir(write_sRGB_dir)
            mkdir(write_sRGB_dir)
        end
        nimname = sprintf([write_sRGB_dir subdir(k).name '_' S{1} '_part' num2str(i) '.JPG']);
        imwrite(cropnI, nimname);
        meanname = sprintf([write_mean_dir subdir(k).name '_mean_' S{1} '_part' num2str(i) '.JPG']);
        imwrite(cropI, meanname);
        %     gI = cropI + 10/255*randn(size(cropI));
        %     gtname = sprintf('G%s_part_%d.png', S{1}, i);
        %     imwrite(gI,gtname);
    end
end