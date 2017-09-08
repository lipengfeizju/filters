function U = riccati_e(P,H,K)
    U = P - K*H*P;
end
