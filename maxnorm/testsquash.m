% d: the dimension of samples
% r: the rank of generated matrix
% N: the number of samples
mu = 0;
d = 10;
r = 5;
N = 20;
lambda = 0.001;
sigma = sqrt(1);
U = mu + sigma * randn(d, r);
U = orth(U);
V = mu + sigma * randn(N, r);
Y = U * V';
X = squash(Y, lambda);