function y = threshholding(x,sorh,t)
%WTHRESH Perform soft or hard thresholding. 
%   Y = WTHRESH(X,SORH,T) returns soft (if SORH = 's')
%   or hard (if SORH = 'h') T-thresholding  of the input 
%   vector or matrix X. T is the threshold value.
%
%   Y = WTHRESH(X,'s',T) returns Y = SIGN(X).(|X|-T)+, soft 
%   thresholding is shrinkage.
%
%   Y = WTHRESH(X,'h',T) returns Y = X.1_(|X|>T), hard
%   thresholding is cruder.

switch sorh
  case 's'
    tmp = bsxfun(@minus, abs(x), t);
    tmp = (tmp+abs(tmp))/2;
    y   = sign(x).*tmp;
 
  case 'h'
    y   = x.*(abs(x)>t);
 
  otherwise
    error(message('Wavelet:FunctionArgVal:Invalid_ArgVal'))
end
