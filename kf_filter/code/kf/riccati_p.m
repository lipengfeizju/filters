function S = riccati_p(S1,A,Q)
    S = A*S1*A'+Q;
end
