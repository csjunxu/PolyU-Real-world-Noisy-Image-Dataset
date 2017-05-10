function rgb = demosaick(raw, pattern)

% guided filter epsilon
eps = 1e-10;
% guidede filter window size
h = 5;
v = 5;

% mosaic and mask
num = zeros(size(pattern));
p = find((pattern == 'r') + (pattern == 'R'));
num(p) = 1;
p = find((pattern == 'g') + (pattern == 'G'));
num(p) = 2;
p = find((pattern == 'b') + (pattern == 'B'));
num(p) = 3;
mask = zeros(size(raw, 1), size(raw, 2), 3);

rows1 = 1:2:size(raw, 1);
rows2 = 2:2:size(raw, 1);
cols1 = 1:2:size(raw, 2);
cols2 = 2:2:size(raw, 2);

mask(rows1, cols1, num(1)) = 1;
mask(rows1, cols2, num(2)) = 1;
mask(rows2, cols1, num(3)) = 1;
mask(rows2, cols2, num(4)) = 1;

mosaic(:, :, 1) = raw(:, :) .* mask(:, :, 1);
mosaic(:, :, 2) = raw(:, :) .* mask(:, :, 2);
mosaic(:, :, 3) = raw(:, :) .* mask(:, :, 3);

% [mosaic mask] = mosaic_bayer(mosaic, pattern);

% green interpolation
green = green_interpolation(mosaic, mask, pattern, eps);

% red and blue interpolation
red  =  red_interpolation(green, mosaic, mask, h, v, eps);
blue = blue_interpolation(green, mosaic, mask, h, v, eps);

% result image
rgb = zeros(size(mosaic));
rgb(:,:,1) = red;
rgb(:,:,2) = green;
rgb(:,:,3) = blue;

end

