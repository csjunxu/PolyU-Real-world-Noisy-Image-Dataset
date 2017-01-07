clear;
% Original_image_dir  =    'C:\Users\csjunxu\Desktop\PGPD_TIP\Kodak24\kodak_color\';
Original_image_dir  =    './';
fpath = fullfile(Original_image_dir, '*.png');
im_dir  = dir(fpath);
im_num = length(im_dir);

par.step = 4; % the step of two neighbor patches
par.ps = 8; % patch size
par.changeD = 3;
nlsp = 40;
par.Win = min(2*par.ps, 20);
par.IteNum = 1;
par.rank = min(nlsp, par.ps^2); %
for lambda1 = [0 0.05]
    par.lambda1 = lambda1;
    for lambda2 = [0 0.05]
        par.lambda2 = lambda2;
        % record all the results in each iteration
        par.PSNR = zeros(par.IteNum,im_num,'double');
        par.SSIM = zeros(par.IteNum,im_num,'double');
        T512 = [];
        T256 = [];
        for i = 1:im_num
            par.nlsp = nlsp;  % number of non-local patches
            par.increase = 2;
            par.image = i;
            par.I =  im2double( imread(fullfile(Original_image_dir, im_dir(i).name)) );
            S = regexp(im_dir(i).name, '\.', 'split');
            fprintf('The image is %s:', im_dir(i).name);
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
            imname = sprintf('Noisy_nSig%d_%s',nSig,im_dir(i).name);
            imwrite(par.In,imname);
            %%noiseless image
            par.tI = rgb2cfa(par.I);
            
            fprintf('%s :\n',im_dir(i).name);
            PSNR =   csnr( par.mI*255, par.tI*255, 0, 0 );
            SSIM      =  cal_ssim( par.mI*255, par.tI*255, 0, 0 );
            fprintf('The initial value of PSNR = %2.4f, SSIM = %2.4f \n', PSNR,SSIM);
            %%%%%%%%%%2. denoising%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [im_out,par]  =  MNM_Denoising(par);
            im_out(im_out>1)=1;
            im_out(im_out<0)=0;
            % calculate the PSNR
            par.PSNR(par.IteNum,par.image)  =   csnr( im_out*255, par.tI*255, 0, 0 );
            par.SSIM(par.IteNum,par.image)      =  cal_ssim( im_out*255, par.tI*255, 0, 0 );
            fprintf('%s : PSNR = %2.4f, SSIM = %2.4f \n',im_dir(i).name, par.PSNR(par.IteNum,par.image),par.SSIM(par.IteNum,par.image)     );
            %%%%%%%%%%%%3. color demosaicking
            %We use the following method for color demosaicking
            %L. Zhang and X. Wu, Color demosaicking via directional linear minimum mean square-error estimation,?
            %IEEE Trans. on Image Processing, vol. 14, pp. 2167-2178, Dec. 2005.
            dmI=dmsc(im_out*255);
            fprintf('%s : PSNR =', im_dir(i).name);
            csnr(dmI,par.I*255,20,20)
            fprintf('\n SSIM =');
            cal_ssim(dmI, par.I*255,20,20)
            imname = sprintf('MNM_nSig%d_lambda1%2.2f_lambda2%2.2f_%s',nSig,lambda1,lambda2,im_dir(i).name);
            imwrite(dmI/255,imname);
        end
        mPSNR=mean(par.PSNR,2);
        [~, idx] = max(mPSNR);
        PSNR =par.PSNR(idx,:);
        SSIM = par.SSIM(idx,:);
        mSSIM=mean(SSIM,2);
        fprintf('The best PSNR result is at %d iteration. \n',idx);
        fprintf('The average PSNR = %2.4f, SSIM = %2.4f. \n', mPSNR(idx),mSSIM);
        name = sprintf('MNM_fence_nSig%d_%2.2f_%2.2f.mat',nSig,lambda1,lambda2);
        save(name,'nSig','PSNR','SSIM','mPSNR','mSSIM');
    end
end