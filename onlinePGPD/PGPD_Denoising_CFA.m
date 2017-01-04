clear;
Original_image_dir  =    '../pca_cfa_denoising/';
fpath = fullfile(Original_image_dir, '*.tif');
im_dir  = dir(fpath);
im_num = length(im_dir);

par.step = 4; % the step of two neighbor patches
par.ps = 8; % patch size
par.changeD = 3;
nlsp = 10;
par.Win = min(2*par.ps,16);

for cls_num= [32]
    par.cls_num = cls_num; % number of clusters
    for c1 = 0.1:0.1:1
        par.c1 = c1*2*sqrt(2);
        par.IteNum = 3*par.changeD;
        % record all the results in each iteration
        par.PSNR = zeros(par.IteNum,im_num,'single');
        par.SSIM = zeros(par.IteNum,im_num,'single');
        T512 = [];
        T256 = [];
        for i = 1:im_num
            par.nlsp = nlsp;  % number of non-local patches
            par.increase = 2;
            par.image = i;
            par.I =  im2double( imread(fullfile(Original_image_dir, im_dir(i).name)) );
            S = regexp(im_dir(i).name, '\.', 'split');
            [h,w,ch]=size(par.I);
            %%%%%%%%%%%%%
            nSig=12;
            par.nSig = nSig/255;
            vr=1;
            vb=1;
            vg=1;
            randn('seed',0);
            noi=par.nSig*randn(h,w);
            par.In(:,:,1)=par.I(:,:,1)+vr*noi;
            par.In(:,:,2)=par.I(:,:,2)+vg*noi;
            par.In(:,:,3)=par.I(:,:,3)+vb*noi;
            %%%%%%%%%%1. downsampling to Bayer pattern: CFA noisy image%%%%
            %%noisy image
            par.mI(1:h,1:w)=par.In(:,:,2);
            par.mI(1:2:h,2:2:w)=par.In(1:2:h,2:2:w,1);
            par.mI(2:2:h,1:2:w)=par.In(2:2:h,1:2:w,3);
            %%noiseless image
            par.tI(1:h,1:w)=par.I(:,:,2);
            par.tI(1:2:h,2:2:w)=par.I(1:2:h,2:2:w,1);
            par.tI(2:2:h,1:2:w)=par.I(2:2:h,1:2:w,3);
            %                     snro=csnr(par.mI,par.tI,20,20)
            
            fprintf('%s :\n',im_dir(i).name);
            PSNR =   csnr( par.mI*255, par.tI*255, 0, 0 );
            SSIM      =  cal_ssim( par.mI*255, par.tI*255, 0, 0 );
            fprintf('The initial value of PSNR = %2.4f, SSIM = %2.4f \n', PSNR,SSIM);
            %%%%%%%%%%2. denoising%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
            [im_out,par]  =  Denoising(par);
            im_out(im_out>1)=1;
            im_out(im_out<0)=0;
            % calculate the PSNR
            par.PSNR(par.IteNum,par.image)  =   csnr( im_out*255, par.tI*255, 0, 0 );
            par.SSIM(par.IteNum,par.image)      =  cal_ssim( im_out*255, par.tI*255, 0, 0 );
            imname = sprintf('nSig%d_clsnum%d_c%2.2f_%s',nSig,cls_num,c1,im_dir(i).name);
            imwrite(im_out,imname);
            fprintf('%s : PSNR = %2.4f, SSIM = %2.4f \n',im_dir(i).name, par.PSNR(par.IteNum,par.image),par.SSIM(par.IteNum,par.image)     );
            %%%%%%%%%%%%3. color demosaicking
            %We use the following method for color demosaicking
            %L. Zhang and X. Wu, Color demosaicking via directional linear minimum mean square-error estimation,?
            %IEEE Trans. on Image Processing, vol. 14, pp. 2167-2178, Dec. 2005.
            dmI=dmsc(im_out);
            PSNR=csnr(dmI*255,par.I*255,20,20);
            SSIM=cal_ssim( dmI*255, par.I*255, 0, 0 );
            fprintf('%s : PSNR = %2.4f, SSIM = %2.4f \n',im_dir(i).name, PSNR, SSIM);
        end
        mPSNR=mean(par.PSNR,2);
        [~, idx] = max(mPSNR);
        PSNR =par.PSNR(idx,:);
        SSIM = par.SSIM(idx,:);
        mSSIM=mean(SSIM,2);
        fprintf('The best PSNR result is at %d iteration. \n',idx);
        fprintf('The average PSNR = %2.4f, SSIM = %2.4f. \n', mPSNR(idx),mSSIM);
        name = sprintf('nSig%d_clsnum%d_c%2.2f.mat',nSig,cls_num,c1);
        save(name,'nSig','PSNR','SSIM','mPSNR','mSSIM');
    end
end