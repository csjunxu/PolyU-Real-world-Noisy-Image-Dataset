function X = squash(Y, lambda)
% This function solves the following problem:
% \min_{X} \|Y - X\|_{F}^{2} + \|X\|_{2,Inf}^{2}
% Input: Y: d x N matrix
%           lambda: positive scalar
% Output: X: d x N matrix
X = zeros(size(Y));
d = size(Y, 1);
n = zeros(d, 1);
for k = 1 : d
    n(k, 1) = norm(Y(k, :), 2);
end
[ns, P] = sort(n, 'descend'); % ns = n(P)
s = zeros(d, 1);
ind = [];
for k = 1 : d
    s(k, 1) = sum(ns(1:k), 1); % or s(k, 1) = sum(n(P(1):P(k), 1));
    if n(P(k), 1) >= s(k, 1) / (k+lambda)
        ind = [ind k];
    end
end
q = max(ind);
eta = s(q, 1) / (q + lambda);
for k = 1 : d
    if k <= q
        X(P(k), :) = eta * Y(P(k), :) / norm(Y(P(k), :),2);
    else
        X(P(k), :) = Y(P(k), :);
    end
end