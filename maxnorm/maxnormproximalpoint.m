function [L, R] = maxnormproximalpoint(Y, param)
% a proximal-point method for max-norm regularization problem
% alpha>0, 0<gamma<1, tol>0, tau>0, mu>0

[U, S, V] = svd(Y);

% Initialization
L0 = U;
R0 = V * S';
A0 = [L0; R0];
k = 0;
Ak = A0;
L = L0;
R = R0;
Flag = true;
while Flag
    %% 1 squash function
    Df = -2 * [(Y - L * R') * R; (Y' - R * L') * L];
    Akhat = squash(Ak - param.tau/2 * Df, param.tau * param.mu);
    if ( norm(Ak-Akhat)/norm(Ak) < param.tol )
        Flag = false;
    end
    %% 2 Compute the smallest nonnegative intergel "ell" which satisfy:
    % Phi1 > Phi2 -  alpha * gamma^ell * norm(Ak - Akhat);
    ell = 0;
    L1 = Akhat(1:size(U,1), 1:size(U,2));
    R1 = Akhat(size(U,1) + 1:end, 1:size(U,2));
    Phi1 = norm(Y - L1 * R1') + param.mu * max(sum(Akhat.^2, 2));
    L2 = Ak(1:size(U,1), 1:size(U,2));
    R2 = Ak(size(U,1) + 1:end, 1:size(U,2));
    Phi2 = norm(Y - L2 * R2') + param.mu * max(sum(Ak.^2, 2));
    while Phi1 > Phi2 - param.alpha * param.gamma^ell * norm(Ak - Akhat);
        ell = ell + 1;
        A1 = Ak + param.gamma^ell * (Akhat - Ak);
        L1 = A1(1:size(U,1), 1:size(U,2));
        R1 = A1(size(U,1) + 1:end, 1:size(U,2));
        Phi1 = norm(Y - L1 * R1') + param.mu * max(sum(A1.^2, 2));
        L2 = Ak(1:size(U,1), 1:size(U,2));
        R2 = Ak(size(U,1) + 1:end, 1:size(U,2));
        Phi2 = norm(Y - L2 * R2') + param.mu * max(sum(Ak.^2, 2));
    end
    %% 3 update the matrix Ak
    Ak = (1 - param.gamma^ell) * Ak + param.gamma^ell * Akhat;
    L = Ak(1:size(U,1), 1:size(U,2));
    R = Ak(size(U,1) + 1:end, 1:size(U,2));
    %% 4 update the counter and the paramameter "tau"
    k = k + 1;
    param.tau = param.tau/sqrt(k);
end