function hatK = Loss_Method_Absolute_Objective(A)

n = max(size(A));
tau0 = 1.0;

[U S V] = svd(A,0);
R = V*sqrt(S);
X = zeros(size(A));

for k=1:2000

    tau = tau0 / sqrt(k);
    lambda = 2^(-floor(k/100));
    
    Xu = X + tau * (A - X - R*R');
    for i=1:n
        for j=1:n
            if (sign(Xu(i,j))* sign( Xu(i,j) - tau*lambda*sign(X(i,j)) )==-1)
                Xu(i,j) = 0;
            else
                Xu(i,j) = Xu(i,j) - tau * lambda * sign(X(i,j));
            end
        end
    end
    X = Xu;
    
    Ru = R + tau * 2 * (A - X - R*R') * R;
    Ru(find(Ru<0)) = 0;
    for i=1:n
        nrm = norm(Ru(i,:));
        if (nrm > 1)
            Ru(i,:) = Ru(i,:)/nrm;
        end
    end
    
    R = Ru;
end

hatK = round(A - X);
