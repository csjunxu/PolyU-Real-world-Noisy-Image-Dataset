function hatK = SDP_L1_MAX_Solver(A)

yalmip('clear');

[n m] = size(A);
X = sdpvar(n,m,'full');
L = sdpvar(n);
R = sdpvar(m);

W = [L X;X' R];
c = set(W>=0) + set(diag(L)<=1) + set(diag(R)<=1);
obj = sum(sum(abs(A-X)));

solvesdp(c,obj,sdpsettings('showprogress',1,'verbose',0,'solver','dsdp'));

hatK = round(double(X));

