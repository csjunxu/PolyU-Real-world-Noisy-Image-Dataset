
clear;
% Original_image_dir  =    'C:\Users\csjunxu\Desktop\PGPD_TIP\Kodak24\kodak_color\';
Original_image_dir  = './';
fpath = fullfile(Original_image_dir, '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);

par.step = 4; % the step of two neighbor patches
par.ps = 8; % patch size
par.nlsp = 40;
par.Win = min(4*par.ps, 16);
par.IteNum = 1;
tol = 1e-3;
param.tol = tol;
for alpha = 0:0.1:1
    param.alpha = alpha;
    for gamma = 0:0.1:1;
        param.gamma = gamma;
        for tau = 0:0.1:1;
            param.tau = tau;
            for mu = 0:0.1:1;
                param.mu = mu;
                % record all the results in each iteration
                par.PSNR = zeros(par.IteNum,im_num,'double');
                par.SSIM = zeros(par.IteNum,im_num,'double');
                for i = 1:im_num
                    par.image = i;
                    par.I =  im2double( imread(fullfile(Original_image_dir, im_dir(i).name)) );
                    S = regexp(im_dir(i).name, '\.', 'split');
                    fprintf('The image is %s:\n', im_dir(i).name);
                    [h,w,ch]=size(par.I);
                    %%%%%%%%%%%%%
                    nSig=12;
                    par.nSig = nSig/255;
                    vr=1;
                    vb=1;
                    vg=1;
                    randn('seed',0);
                    noi=par.nSig*randn(h,w);
                    par.In = zeros(size(par.I));
                    par.In(:,:,1)=par.I(:,:,1)+vr*noi;
                    par.In(:,:,2)=par.I(:,:,2)+vg*noi;
                    par.In(:,:,3)=par.I(:,:,3)+vb*noi;
                    %%%%%%%%%%1. downsampling to Bayer pattern: CFA noisy image%%%%
                    %%noisy image
                    par.mI = rgb2cfa(par.In);
                    %%noiseless image
                    par.tI = rgb2cfa(par.I);
                    
                    PSNR =   csnr( par.mI*255, par.tI*255, 0, 0 );
                    SSIM      =  cal_ssim( par.mI*255, par.tI*255, 0, 0 );
                    fprintf('The initial value of PSNR = %2.4f, SSIM = %2.4f \n', PSNR,SSIM);
                    %%%%%%%%%%2. denoising%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
                    [rim, par]  =  MaxNorm_Denoising(par, param);
                    rim(rim>1)=1;
                    rim(rim<0)=0;
                    % calculate the PSNR
                    par.PSNR(par.IteNum,par.image)  =   csnr( rim*255, par.tI*255, 0, 0 );
                    par.SSIM(par.IteNum,par.image)      =  cal_ssim( rim*255, par.tI*255, 0, 0 );
                    %             imname = sprintf('nSig%d_clsnum%d_c%2.2f_%s',nSig,cls_num,c1,im_dir(i).name);
                    %             imwrite(im_out,imname);
                    fprintf('%s : PSNR = %2.4f, SSIM = %2.4f \n',im_dir(i).name, par.PSNR(par.IteNum,par.image),par.SSIM(par.IteNum,par.image)     );
                    %%%%%%%%%%%%3. color demosaicking
                    %We use the following method for color demosaicking
                    %L. Zhang and X. Wu, Color demosaicking via directional linear minimum mean square-error estimation,?
                    %IEEE Trans. on Image Processing, vol. 14, pp. 2167-2178, Dec. 2005.
                    dmI=dmsc(rim*255);
                    fprintf('%s : PSNR =', im_dir(i).name);
                    csnr(dmI,par.I*255,20,20)
                    fprintf('\n SSIM =');
                    cal_ssim(dmI, par.I*255,20,20)
                end
                mPSNR=mean(par.PSNR,2);
                [~, idx] = max(mPSNR);
                PSNR =par.PSNR(idx,:);
                SSIM = par.SSIM(idx,:);
                mSSIM=mean(SSIM,2);
                fprintf('The best PSNR result is at %d iteration. \n',idx);
                fprintf('The average PSNR = %2.4f, SSIM = %2.4f. \n', mPSNR(idx),mSSIM);
                name = sprintf('MaxNormCFA_nSig%d_alpha%2.2f_gamma%2.2f_tau%2.2f_mu%2.2f.mat',nSig,alpha,gamma,tau,mu);
                save(name,'nSig','PSNR','SSIM','mPSNR','mSSIM');
            end
        end
    end
end
