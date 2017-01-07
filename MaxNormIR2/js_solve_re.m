% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% solve the problem: 
%   min_{r, e} 0.5 * || z - L*r - e ||_2^2 + \lambda_2 || e ||_1, s.t. || r ||_2 <= 1
%
% r: d * 1, optimal basis
% e: p * 1, optimal sparse error
% z: p * 1, observed data
% L: basis computed in the previous iteration
% lambda2: parameter
%
% Copyright by Jie Shen, js2007@rutgers.edu

function [R, E] = js_solve_re(Z, L, lambda2)

% initialization
[p, d] = size(L);
[p, n] = size(Z);
R = zeros(n, d);
E = zeros(p, n);

converged = false;
maxIter = 100;
iter = 0;

I = eye(d, d);

% alternatively update
LLtinv = (L'* L + 0.01 * I) \ L';
% LLtinv = pinv(L' * L) * L';

% LtL_pad = [L' * L; zeros(1, d)];

while ~converged
    iter = iter + 1;
    rorg = R;
    
    diff_ze = Z - E;
    
%     r0 = (L' * L + 0.0001 * I) \ (L' * diff_ze);
    Rt = LLtinv * diff_ze;
%     r0 = LtL_pad \ [L' * diff_ze; 0];
    norm_Rt = max(sum(Rt.^2, 1)); %?
    
    if norm_Rt <= 1
        R = Rt';
    else
        [R, eta] = js_solve_r( L, diff_ze);
    end
    
    eorg = E;
    
    % soft-thresholding
    E = threshholding(Z - L * R', 's', lambda2);
    
    stopc = max(norm(E - eorg), norm(R - rorg))/ p;
    
    if stopc < 1e-6 || iter > maxIter
        converged = true;
    end
end

end


