clear;

Original_image_dir  =    './';
fpath = fullfile(Original_image_dir, '*.JPG');
im_dir  = dir(fpath);
im_num = length(im_dir);
for i =1:im_num
    Im = im2double(imread(fullfile(Original_image_dir, im_dir(i).name)));
    [h , w, ch] = size(Im);
    if h <= w
        RIm = imresize(Im, 0.4);
    else
        RIm = imresize(permute(Im, [2 1 3]), 0.4);
    end
    imwrite(RIm, ['./resize_' im_dir(i).name]);
end
