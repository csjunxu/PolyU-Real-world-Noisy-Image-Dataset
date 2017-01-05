function  [im_out,par]    =   MaxNorm_Denoising(par, param)
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
    %     % PG-GMM training
    %     if mod(ite-1,par.changeD)==0
    %         [model,~,cls_idx] = emgm(nDCnlX,par);
    %         % cluster segmentation
    %         [idx,  s_idx]    =  sort(cls_idx);
    %         idx2   =  idx(1:end-1) - idx(2:end);
    %         seq    =  find(idx2);
    %         seg    =  [0; seq; length(cls_idx)];
    %     end
    %     % estimation of noise variance
    if ite==1
        par.nSig = par.nSig0;
    else
        dif = mean( mean( (par.mI-im_out).^2 ) ) ;
        par.nSig = sqrt( abs( par.nSig0^2 - dif ) );
    end
    % Sparse Coding
    X_hat = zeros(par.ps^2,par.maxr*par.maxc, 'double');
    W = zeros(par.ps^2,par.maxr*par.maxc, 'double');
    for i = 1:size(blk_arr, 2)
        idx    =   blk_arr(:, i);
        Y         =   nDCnlX(:,idx);
        [L, R] = maxnormproximalpoint(Y, param);
        Yhat = L * R';
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
    %     if mod(ite,par.changeD)==0
    %         par.nlsp = par.nlsp + par.increase;
    %     end
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
        idx     =   Index(rmin:2:rmax, cmin:2:cmax);
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

function [model,llh,label]= emgm(X, par)
% Perform EM algorithm for fitting the Gaussian mixture model.
%   X: d x n data matrix
%   init: k (1 x 1) or label (1 x n, 1<=label(i)<=k) or center (d x k)
% Written by Michael Chen (sth4nth@gmail.com).
% initialization
fprintf('EM for Gaussian mixture: running ... \n');
R = initialization(X,par.cls_num,par.nlsp);
[~,label(1,:)] = max(R,[],2);
R = R(:,unique(label));
tol = 1e-8;
maxiter = 20;
llh = -inf(1,maxiter);
converged = false;
t = 1;
while ~converged && t < maxiter
    t = t+1;
    model = maximization(X,R,par.nlsp);
    clear R;
    [R, llh(t)] = expectation(X,model,par.nlsp);
    % output
    fprintf('Iteration %d of %d, logL: %.2f\n',t,maxiter,llh(t));
    % output
    %     subplot(1,2,1);
    %     plot(llh(1:t),'o-'); drawnow;
    [~,label(:)] = max(R,[],2);
    u = unique(label);   % non-empty components
    if size(R,2) ~= size(u,2)
        R = R(:,u);   % remove empty components
    else
        converged = llh(t)-llh(t-1) < tol*abs(llh(t));
    end
end
label=label';
if converged
    fprintf('Converged in %d steps.\n',t-1);
else
    fprintf('Not converged in %d steps.\n',maxiter);
end

function R = initialization(X, init,nlsp)
%
index = 1:nlsp:size(X,2);
X = X(:,index);
[d,n] = size(X);
if isstruct(init)  % initialize with a model
    R  = expectation(X,init);
elseif length(init) == 1  % random initialization
    k = init;
    idx = randsample(n,k);
    m = X(:,idx);
    [~,label] = max(bsxfun(@minus,m'*X,dot(m,m,1)'/2),[],1);
    [u,~,label] = unique(label);
    while k ~= length(u)
        idx = randsample(n,k);
        m = X(:,idx);
        [~,label] = max(bsxfun(@minus,m'*X,dot(m,m,1)'/2),[],1);
        [u,~,label] = unique(label);
    end
    R = full(sparse(1:n,label,1,n,k,n));
elseif size(init,1) == 1 && size(init,2) == n  % initialize with labels
    label = init;
    k = max(label);
    R = full(sparse(1:n,label,1,n,k,n));
elseif size(init,1) == d  %initialize with only centers
    k = size(init,2);
    m = init;
    [~,label] = max(bsxfun(@minus,m'*X,dot(m,m,1)'/2),[],1);
    R = full(sparse(1:n,label,1,n,k,n));
else
    error('ERROR: init is not valid.');
end


function [R, llh] = expectation(X, model,nlsp)
%
means = model.means;
covs = model.covs;
w = model.mixweights;
n = size(X,2)/nlsp;
k = size(means,2);
logRho = zeros(n,k);
for i = 1:k
    TemplogRho = loggausspdf(X,means(:,i),covs(:,:,i));
    Temp = reshape(TemplogRho,[nlsp n]);
    logRho(:,i) = sum(Temp);
end
logRho = bsxfun(@plus,logRho,log(w));
T = logsumexp(logRho,2);
llh = sum(T)/n; % loglikelihood
logR = bsxfun(@minus,logRho,T);
R = exp(logR);


function model = maximization(X, R,nlsp)
%
[d,n] = size(X);
R = R(reshape(ones(nlsp,1)*(1:size(R,1)),size(R,1)*nlsp,1),:);
k = size(R,2);
nk = sum(R,1);
w = nk/n;
means = bsxfun(@times, X*R, 1./nk);
Sigma = zeros(d,d,k);
sqrtR = sqrt(R);
for i = 1:k
    Xo = bsxfun(@minus,X,means(:,i));
    Xo = bsxfun(@times,Xo,sqrtR(:,i)');
    Sigma(:,:,i) = Xo*Xo'/nk(i);
    Sigma(:,:,i) = Sigma(:,:,i)+eye(d)*(1e-6); % add a prior for numerical stability
end
model.dim = d;
model.nmodels = k;
model.mixweights = w;
model.means = means;
model.covs = Sigma;



function y = loggausspdf(X, mu, Sigma)
%
d = size(X,1);
X = bsxfun(@minus,X,mu);
%   [R,p] = CHOL(A), with two output arguments, never produces an
%   error message.  If A is positive definite, then p is 0 and R
%   is the same as above.   But if A is not positive definite, then
%   p is a positive integer.
[U,p]= chol(Sigma);
if p ~= 0
    error('ERROR: Sigma is not PD.');
end
Q = U'\X;
q = dot(Q,Q,1);  % quadratic term (M distance)
c = d*log(2*pi)+2*sum(log(diag(U)));   % normalization constant
y = -(c+q)/2;

function s = logsumexp(x, dim)
%
% Compute log(sum(exp(x),dim)) while avoiding numerical underflow.
%   By default dim = 1 (columns).
% Written by Michael Chen (sth4nth@gmail.com).
if nargin == 1,
    % Determine which dimension sum will use
    dim = find(size(x)~=1,1);
    if isempty(dim), dim = 1; end
end
% subtract the largest in each column
y = max(x,[],dim);
x = bsxfun(@minus,x,y);
s = y + log(sum(exp(x),dim));
i = find(~isfinite(y));
if ~isempty(i)
    s(i) = y(i);
end