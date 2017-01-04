function VI = VarInf(K1,K2)

n = max(size(K1));

r1 = rank(K1);
[U1 S1 V1] = svd(K1);
U1 = U1(:,1:r1);
U1(find(abs(U1)<10^-5)) = 0;
U1(find(U1~=0)) = 1;

r2 = rank(K2);
[U2 S2 V2] = svd(K2);
U2 = U2(:,1:r2);
U2(find(abs(U2)<10^-5)) = 0;
U2(find(U2~=0)) = 1;

P1 = sum(U1)./n;
P2 = sum(U2)./n;
P12 = U1'*U2./n;

H1 = -sum(P1.*log(P1)./log(2));
H2 = -sum(P2.*log(P2)./log(2));

I12 = P12.*log(P12./(P1'*P2))./log(2);
I12(isnan(I12))=0;
I12 = sum(sum(I12));

VI = H1 + H2 - 2*I12;

