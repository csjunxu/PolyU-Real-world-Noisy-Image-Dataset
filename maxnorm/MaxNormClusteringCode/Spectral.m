function hatK = Spectral(A,k)

[U S V] = svd(A);
hatK = U(:,1:k)*S(1:k,1:k)*V(:,1:k)';
