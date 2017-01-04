function Y = L1_Conv_Conj(A,mu)

% Solves Y = min ||A-Y||_1  +  << mu, Y>>
Y = A;
[n m] = size(A);
for i=1:n
    for j=1:n
        if (mu(i,j)>1)
            Y(i,j) = -1;
        elseif (mu(i,j)<-1)
            Y(i,j) = 1;
        end
    end
end


