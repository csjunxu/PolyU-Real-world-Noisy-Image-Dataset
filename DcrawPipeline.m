%% 0 read the tiff image
raw = double(imread('20161214/DSC01381.tiff'));

%% 1 Linearization
black = 0;
saturation = 4092 ;
lin_bayer = (raw-black)/(saturation-black); % 归一化至[0,1];
lin_bayer = max(0,min(lin_bayer,1)); % 确保没有大于1或小于0的数据;
imshow(lin_bayer);

%% 2 White Balancing
wb_multipliers = [1.902344, 1, 1.808594]; % for particular condition, from dcraw;
mask = wbmask(size(lin_bayer,1),size(lin_bayer,2),wb_multipliers,'rggb');
balanced_bayer = lin_bayer .* mask;