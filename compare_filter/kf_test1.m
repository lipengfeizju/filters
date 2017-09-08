function [ stater,paramr ] = kf_test1(state,z, param)

    A = [1 0; 0 1];
    xp = A*state;
    Pp = A*param.P*A'+param.Q;
    
    H = [1 0; 0 1];
    yd = z-H*xp;
    Sk = H*Pp*H' + param.R;
    Kk = Pp*H'/Sk;
    
    stater = xp + Kk*yd;
    paramr.P = Pp - Kk*H*Pp;
    paramr.Q = param.Q;
    paramr.R = param.R;
    
end
