function subRAW = spatialaverageB(Raw, W)

% This function average and sub-sampling the raw image to
% obtain the spatially subsampled and averaged image
% the pixelx in the each patch of size WxW is used to compute the average value
% of R or G or B channels for demosaicking


% The input:
%                Raw: Input raw image
%                   W: The size of the window or block
% The output:
%                RGB: The RGB image obtained by subsampling and averaging
%                the input Raw image.

[h, w, ch] = size(Raw);
maxh = floor(h/W);
maxw = floor(w/W);

CutRaw = Raw(1:maxh*W, 1:maxw*W, 1:ch);


if ch ~= 1
    fprintf('The input image is not raw image!');
    return; % ?
end

% sub-sample the Raw image
subRAW = zeros(maxh, maxw, ch);
for i = 1:1:maxh
    for j = 1:1:maxw
        Patchij = CutRaw((i-1)*W+1:i*W, (j-1)*W+1:j*W);
        if       mod(i, 2) == 1 && mod(j, 2) == 1 % red pixel
            subRAW(i, j) = mean(mean(Patchij(1:2:W, 1:2:W)));
        elseif mod(i, 2) == 1 && mod(j, 2) == 0 % green pixel 1
            subRAW(i, j) = mean(mean(Patchij(1:2:W, 2:2:W)));
            subRAW(i+1, j-1) = mean(mean(Patchij(2:2:W, 1:2:W)));
        elseif mod(i, 2) == 0 && mod(j, 2) == 1 % green pixel 2
            subRAW(i, j) = mean(mean(Patchij(2:2:W, 1:2:W)));
            subRAW(i-1, j+1) = mean(mean(Patchij(1:2:W, 2:2:W)));
        elseif mod(i, 2) == 0 && mod(j, 2) == 0 % blue pixel
            subRAW(i, j) = mean(mean(Patchij(2:2:W, 2:2:W)));
        end
    end
end
subRAW = uint16(subRAW);
% imshow(double(subRAW)/255);
% % Raw image to RGB image
% for i = 1:1:maxh
%     for j = 1:1:maxw
%         subRAW(i, j) = mean(CutRaw()); % the red pixel value
%         GB(i, j, 2) = mean(CutRaw()); % the green pixel value
%         GB(i, j, 3) = mean(CutRaw()); % the blue pixel value
%     end
% end

