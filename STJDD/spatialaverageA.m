function subRAW = spatialaverageA(Raw, W)

% This function average and sub-sampling the raw image to
% obtain the spatially subsampled and averaged image
% each pixel in the window of WxW is used to compute the average pixel
% values of the R, G, B channels for demosaicking

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
subRAW = zeros(2*maxh, 2*maxw, ch);
for i = 1:1:maxh
    for j = 1:1:maxw 
        Patchij = CutRaw((i-1)*W+1:i*W, (j-1)*W+1:j*W);
        subRAW((i-1)*2+1, (j-1)*2+1)         = mean(mean(Patchij(1:2:W, 1:2:W))); % the R pixel value
        subRAW((i-1)*2+1, j*2)     = mean(mean([Patchij(1:2:W, 2:2:W);Patchij(2:2:W, 1:2:W)])); % the G1 pixel value
        subRAW(i*2, (j-1)*2+1)     = subRAW(i, j+1); % the G2 pixel value
        subRAW(i*2, j*2) = mean(mean(Patchij(2:2:W, 2:2:W))); % the B pixel value
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

