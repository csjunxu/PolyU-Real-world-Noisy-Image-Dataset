function hatK = Projection_Method_Absolute_Objective(A)

tau0 = 1.0;

[U S V] = svd(A,0);
R = V*sqrt(S);
n = max(size(A));

for k=1:2000
    
    tau = tau0/sqrt(k);
    
    Ru = R + tau * 2 * sign(A - R*R') * R;
    Ru(find(Ru<0)) = 0;
    for i=1:n
        nrm = norm(Ru(i,:));
        if (nrm > 1)
            Ru(i,:) = Ru(i,:)/nrm;
        end
    end
    
    R = Ru;
end

hatK = round(R*R');


