clear all;
close all;
warning('off');

addpath(genpath(pwd));
return1=system('C:\Users\csjunxu\Desktop\Projects\RID_Dataset\dcraw -a -T -4 C:\Users\csjunxu\Desktop\Projects\RID_Dataset\HuiPipeline\DSC01381.ARW');
% return1=system('../dcraw -a -T -4 ../20161214/DSC01381.ARW');
hdr=double(importdata('.\数据\adobe_DNG\DJI_0029.tiff'));
% % hdr=importdata('.\数据\adobe_DNG\DJI_0029fujia.tiff');
maxSize=780;
     if max(size(hdr)) > maxSize
                     ratio = max(size(hdr,1),size(hdr,2))/ maxSize;                     
                    Ori = imresize(hdr, 1/ratio,'bilinear'); 
     else
         Ori=hdr;
         
  end

[w,l,col]=size(Ori);
Ori_gamma=zeros(w,l,col);
Max_Ori=max(Ori(:));
Min_Ori=min(Ori(:));
Ori=Ori/Max_Ori;
fprintf(' tonemapping - global gamma\n');
gamma=0.45;
 for i=1:3
     Ori_gamma(:,:,i)=(Ori(:,:,i).^gamma);
 end
 %scaling to 0-1
%  resultfinal=mat2gray(Ori_gamma);
 figure(1)
%  imshow(resultfinal)
 imshow(Ori_gamma)
 fprintf(' tonemapping - reihardglobal\n');
 key=0.8;
 saturation=0.6;
 [ldr_reihard,luminanceglobal]=reinhardGlobal(Ori,key,saturation);
 figure(2)
%  ldr_reihard=mat2gray(ldr_reihard);
 imshow(ldr_reihard)