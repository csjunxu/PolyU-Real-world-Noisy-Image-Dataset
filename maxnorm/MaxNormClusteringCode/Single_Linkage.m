function [Kabs, Klin] = Single_Linkage(A)

n = max(size(A));

hatK = eye(n);
dissim = (n+1)*eye(n);
for i=1:n
    for j=i+1:n
        dissim(i,j) = sum(abs(A(:,i)-A(:,j)));
        dissim(j,i) = dissim(i,j);
    end
end

bestK1 = hatK;
val1p = sum(sum(abs(A-bestK1)));
bestK2 = hatK;
val2p = sum(bestK2.*(1-2*A));

for cnt=1:n
    
    [X ind] = min(dissim);
    [X j] = min(X);
    i = ind(j);
    
    Indi = find(hatK(:,i(1)) == 1);
    Indj = find(hatK(:,j(1)) == 1);
    hatK(Indi,Indj) = 1;
    hatK(Indj,Indi) = 1;
    dissim(Indi,Indj) = n+1;
    dissim(Indj,Indi) = n+1;

    hatK(i(1),j(1)) = 1;
    hatK(j(1),i(1)) = 1;
    dissim(i(1),j(1)) = n+1;
    dissim(j(1),i(1)) = n+1;
    
    val1 = sum(sum(abs(A-hatK)));
    if (val1<=val1p)
        bestK1 = hatK;
        val1p = val1;
    end
    val2 = sum(sum(hatK.*(1-2*A)));
    if (val2<=val2p)
        bestK2 = hatK;
        val2p = val2;
    end

end    

Kabs = bestK1;
Klin = bestK2;
