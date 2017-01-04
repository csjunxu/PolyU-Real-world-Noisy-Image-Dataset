function hatK = Dual_Method_Absolute_Objective(A)

mu = A;
n = max(size(A));
tau0 = 1.0;

[U S V] = svd(A,0);
R = V*sqrt(S);
for k=1:20

    Y = L1_Conv_Conj(A,mu);

    for cnt=1:100
        tau = tau0 / sqrt(cnt+(k-1)*n);
        Ru = R + tau * 2 * mu  * R ;
        Ru(find(Ru<0)) = 0;
        for i=1:n
            nrm = norm(Ru(i,:));
            if (nrm > 1)
                Ru(i,:) = Ru(i,:)/nrm;
            end
        end
        R = Ru;
    end
    
    mu = mu + tau0*(Y-R*R')/sqrt(k);
end

hatK = round(R*R');
%hatK = round(Y);
