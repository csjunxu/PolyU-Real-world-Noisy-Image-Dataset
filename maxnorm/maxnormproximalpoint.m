function [L, R] = maxnormproximalpoint(Y,alpha,gamma,tau,mu,tol)
% alpha>0, 0<gamma<1, tol>0, tau>0
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
    Df = -2 * [(Y - L * R') * R; (V' - R * L') * L];
    Akhat = squash(Ak - tau/2 * Df, tau * mu);
    if ( norm(Ak-Akhat)/norm(Ak) >= tol )
        Flag = false;
    end
    %% 2 Compute the smallest nonnegative intergel "ell" which satisfy:
    % Phi1 > Phi2 -  alpha * gamma^ell * norm(Ak - Akhat);
    ell = 0;
    A1 = Ak + gamma^ell * (Akhat - Ak);
    L1 = A1(1:size(U,1), 1:size(U,2));
    R1 = A1(size(U,1) + 1:end, 1:size(U,2));
    Phi1 = norm(Y - L1 * R1') + mu * max(sum(A1.^2, 2));
    L2 = Ak(1:size(U,1), 1:size(U,2));
    R2 = Ak(size(U,1) + 1:end, 1:size(U,2));
    Phi2 = norm(Y - L2 * R2') + mu * max(sum(Ak.^2, 2));
    while Phi1 > Phi2 -  alpha * gamma^ell * norm(Ak - Akhat);
        ell = ell + 1;
    end
    %% 3 update the matrix Ak
    Ak = (1 - gamma^ell) * Ak + gamma^ell * Akhat;
    L = Ak(1:size(U,1), 1:size(U,2));
    R = Ak(size(U,1) + 1:end, 1:size(U,2));
    %% 4 update the counter and the parameter "tau"
    k = k + 1;
    tau = tau/sqrt(k);
end