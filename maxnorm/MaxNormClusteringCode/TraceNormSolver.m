function hatK = TraceNormSolver(Z)

[n m] = size(Z);
tau0 = 1.0;

L = zeros(size(Z));

for cnt=1:n*m
    tau = tau0/sqrt(cnt);
    
    L1 = L + tau*sign(Z-L);
    for i=1:n
        for j=1:m
            if (sign(Z(i,j)-L(i,j))*sign(Z(i,j)-L1(i,j))==-1)
                L1(i,j) = Z(i,j);
            end
        end
    end
    
    [U S V] = svd(L1);
    s = 0;
    for i=1:n
        s = s + S(i,i);
        if (s>=n)
            S(i,i) = S(i,i) - s + n;
            for j=i+1:n
                S(j,j)=0;
            end
            break
        end
    end
    L = U*S*V';
    
end

hatK = round(L);

