function [A,K] = Generate_Graph(C,Pe)

K=ones(C(1));
for i=2:max(size(C))
    K = [K zeros(sum(C(1:i-1)),C(i)); zeros(C(i),sum(C(1:i-1))) ones(C(i))];
end

B = double(rand(size(K))>1-Pe);
A = K;
for i=1:sum(C)
    for j=i+1:sum(C)
        if (B(i,j) == 1)
            A(i,j) = 1 - K(i,j);
            A(j,i) = 1 - K(j,i);
        end
    end
end
