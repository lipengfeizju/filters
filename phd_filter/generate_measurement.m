x_intial = [0.2 0.7;0.8 0.3];
z_num = [2 3 1 4];
z_num = [z_num z_num ];
z_num = [z_num z_num ];
z_ob = {};
for i = 1:4
    z_ob{4*i-3} = [0 1;1 0] + 0.1*randn(2,2);
    z_ob{4*i-2} = [0 1 10*randn;1 0 10*randn] + 0.1*randn(2,3);
    z_ob{4*i-1} = [mod(i,2);mod(i+1,2)] + 0.1*randn(2,1);
    z_ob{4*i} = [0 1 10*randn 10*randn;1 0 10*randn 10*randn] + 0.1*randn(2,4);
end
