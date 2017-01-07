% This code is used for the NIPS work "Online Optimization for Max-Norm Regularization", Jie Shen, Huan Xu, Ping Li
%
% Main entry point for solving online max-norm regularized matrix decomposition prbolem (OMRMD)
%   min_{L, R, E} \sum_{i=1}^n (0.5 * || z_i - L*r_i - e_i ||_2^2 + \lambda_2 || e_i ||_1) + \frac{\lambda_1}{2} || L ||_{2, \infty}^2
%   s.t.          || r_i ||_2 <= 1, i=1,2,...,n
%
% L: p * d, optimal basis
% R: n * d, coefficients
% E: p * n, sparse error
% Z: p * n, data matrix
% d: assumed rank of Z
% lambda1, lambda2: two tunable parameters
%
% Copyright by Jie Shen, js2007@rutgers.edu

% warning: Don't use this function for large-scale testing, as L_est is the collection of all past basis!!!
% For large-scale testing, see large_mrmd.m for reference.

function Yhat = js_solve_mrmd( Z, d, lambda1 )

%% initialization
[p, n] = size(Z);
[L_est, ~, ~] = svd(Z, 'econ');
L_est = L_est(:,1:d);
% R_est = zeros(n, d);
% L_est = rand(p, d);

% converged = false;
% maxIter = 100;
% iter = 0;
% while ~converged
%     iter = iter + 1;
%     pre = 0.5 * norm(Z - L_est * R_est', 'fro')^2 + lambda1 / 2 * max(sum(L_est.^2, 2));
A = zeros(d, d);
B = zeros(p, d);

R_est = js_solve_re(Z, L_est);

for t = 1:n
    A = A + R_est(t, :)' * R_est(t, :);
    B = B + Z(:, t) * R_est(t, :);
end

%         display(sprintf('rank(A) = %f, det(A) = %f', rank(A), det(A) / t));

L_est = js_solve_L(L_est, A, B, lambda1);
Yhat = L_est * R_est';
%display(sprintf('norm of L = %f', norm(L_est{t+1}, 'fro')));

%     cur = 0.5 * norm(Z - Yhat, 'fro')^2 + lambda1 / 2 * max(sum(L_est.^2, 2));
%     stopc = pre - cur;
%     if stopc < 1e-6 || iter > maxIter
%         converged = true;
%     end
% end
end

