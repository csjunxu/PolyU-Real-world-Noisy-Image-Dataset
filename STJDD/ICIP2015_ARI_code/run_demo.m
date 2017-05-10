%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% 
%   Implementation of
%       'Adaptive Residual Interpolation for Color Image Demosaicking' 
% 
%   This code is available only for reserch purpose.
%   If you use this code for future publications,
%   please cite the following paper.
% 
%   Yusuke Monno, Daisuke Kiku, Masayuki Tanaka, and Masatoshi Okutomi,
%   'Adaptive Residual Interpolation for Color Image Demosaicking',
%   IEEE International Conference on Image Processing, 2015.
% 
%   Copyright (C) 2015 Yusuke Monno and Daisuke Kiku. All rights reserved.
%   ymonno@ok.ctrl.titech.ac.jp 
%   http://www.ok.ctrl.titech.ac.jp/~ymonno/
%
%   September 25, 2015.
% 
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
clear all;

% read image
rgb = imread( '1.tif' );

% cast to double
rgb = double(rgb);

% mosaic pattern
% G R ..
% B G ..
% : :   
pattern = 'grbg';

% demosaicking
rgb2 = demosaick(rgb, pattern);

% calculate PSNR and CPSNR
 psnr =  impsnr(rgb, rgb2, 255, 10);
cpsnr = imcpsnr(rgb, rgb2, 255, 10);

% save image
imwrite(uint8(rgb2), '1_pro.tiff');

% print PSNR
fprintf('IMAX\n');
fprintf('Red   : %g\n', psnr(1));
fprintf('Green : %g\n', psnr(2));
fprintf('Blue  : %g\n', psnr(3));
fprintf('CPSNR : %g\n', cpsnr);


