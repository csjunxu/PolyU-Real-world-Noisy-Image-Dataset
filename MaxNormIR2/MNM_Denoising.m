function  [im_out,par]    =   MNM_Denoising(par)
im_out    =   par.mI;
par.nSig0 = par.nSig;
% parameters for noisy image
[h,  w]      =  size(im_out);
par.maxr = h-par.ps+1;
par.maxc = w-par.ps+1;
par.h = h;
par.w = w;
r          =  1:par.step:par.maxr;
par.r          =  [r r(end)+1:par.maxr];
c          =  1:par.step:par.maxc;
par.c          =  [c c(end)+1:par.maxc];
par.lenr = length(par.r);
par.lenc = length(par.c);
par.ps2 = par.ps^2;
par.maxrc = par.maxr*par.maxc;
par.lenrc = par.lenr*par.lenc;
for ite  =  1 : par.IteNum
    % searching  non-local patches
    [nDCnlX,blk_arr,DC,par] = CalNonLocal( im_out, par);
    % Sparse Coding
    X_hat = zeros(par.ps^2,par.maxr*par.maxc, 'double');
    W = zeros(par.ps^2,par.maxr*par.maxc, 'double');
    for i = 1:size(blk_arr, 2)
        i
        idx    =   blk_arr(:,i);
        Y         =   nDCnlX(:, idx);
        [L_est, R_est, ~] = js_solve_mrmd(Y, par.rank, par.lambda1, par.lambda2);
        Yhat = L_est * R_est';
        % add DC components and aggregation
        X_hat(:,blk_arr(:,i)) = X_hat(:,blk_arr(:,i))+bsxfun(@plus, Yhat, DC(:,i));
        W(:,blk_arr(:,i)) = W(:,blk_arr(:,i))+ones(par.ps^2,par.nlsp);
    end
    % Reconstruction
    im_out   =  zeros(h,w,'double');
    im_wei   =  zeros(h,w,'double');
    r = 1:par.maxr;
    c = 1:par.maxc;
    k = 0;
    for i = 1:par.ps
        for j =1:par.ps
            k    =  k+1;
            im_out(r-1+i,c-1+j)  =  im_out(r-1+i,c-1+j) + reshape( X_hat(k,:)', [par.maxr par.maxc]);
            im_wei(r-1+i,c-1+j)  =  im_wei(r-1+i,c-1+j) + reshape( W(k,:)', [par.maxr par.maxc]);
        end
    end
    im_out  =  im_out./(im_wei+eps);
    % calculate the PSNR
    PSNR =   csnr( im_out*255, par.tI*255, 0, 0 );
    SSIM      =  cal_ssim( im_out*255, par.tI*255, 0, 0 );
    fprintf('Iter %d : PSNR = %2.4f, SSIM = %2.4f\n',ite, PSNR,SSIM);
    par.PSNR(ite,par.image) = PSNR;
    par.SSIM(ite,par.image) = SSIM;
end

function       [nDCnlX,blk_arr,DC,par] = CalNonLocal( im, par)
% record the non-local patch set and the index of each patch in
% of seed patches in image
im         =  double(im);
X          =  zeros(par.ps^2, par.maxr*par.maxc, 'double');
k    =  0;
for i  = 1:par.ps
    for j  = 1:par.ps
        k    =  k+1;
        blk  = im(i:end-par.ps+i,j:end-par.ps+j);
        X(k,:) = blk(:)';
    end
end
% index of each patch in image
Index     =   (1:par.maxr*par.maxc);
Index    =   reshape(Index,par.maxr,par.maxc);
% record the indexs of patches similar to the seed patch
blk_arr   =  zeros(par.nlsp, par.lenr*par.lenc ,'double');
% non-local patch sets of X
DC = zeros(par.ps^2,par.lenr*par.lenc,'double');
nDCnlX = zeros(par.ps^2,par.lenr*par.lenc*par.nlsp,'double');
for  i  =  1 :par.lenr
    for  j  =  1 : par.lenc
        row = par.r(i);
        col = par.c(j);
        off = (col-1)*par.maxr + row;
        off1 = (j-1)*par.lenr + i;
        % the range indexes of the window for searching the similar patches
        rmin    =   max( row-par.Win, 1 );
        rmax    =   min( row+par.Win, par.maxr );
        cmin    =   max( col-par.Win, 1 );
        cmax    =   min( col+par.Win, par.maxc );
        idx     =   Index(rmin:2:rmax, cmin:2:cmax); % For CFA pattern
        idx     =   idx(:);
        neighbor       =   X(:,idx); % the patches around the seed in X
        seed       =   X(:,off);
        dis = sum(bsxfun(@minus,neighbor, seed).^2,1);
        [~,ind]   =  sort(dis);
        indc        =  idx( ind( 1:par.nlsp ) );
        blk_arr(:,off1)  =  indc;
        temp = X( : , indc );
        DC(:,off1) = mean(temp,2);
        nDCnlX(:,(off1-1)*par.nlsp+1:off1*par.nlsp) = bsxfun(@minus,temp,DC(:,off1));
    end
end