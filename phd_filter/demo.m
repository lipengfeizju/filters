clear;
clc;
load('data.mat');
N = length(z_num);
x_mean = cell(1,N+1);x_cov = cell(1,N+1) ;x_weight = cell(1,N+1);x_num = zeros(1,N+1);
x_mean{1} = x_intial;
x_cov{1} = ob_cov;
x_weight{1} = weight_intial;
x_num(1) = num_intial;

for i = 1:N
    
    [x_numr, x_weightr, x_meanr , x_covr] = phd_filter(x_num(i), ...
    x_weight{i}, x_mean{i} , x_cov{i}, z_num(i), z_ob{i} );

    x_num(i+1) = x_numr;
    x_weight{i+1} = x_weightr;
    x_mean{i+1} = x_meanr;
    x_cov{i+1} = x_covr;
end
save('result.mat','x_num','x_weight','x_mean','x_cov');


%plot the result
z = zeros(81,81);
z(200) = 1;
x = -2:0.05:2;
y = -2:0.05:2;

[x1,y1] = meshgrid(-2:0.05:2);
k = 1:81*81;
calDataRan2 = @(j) (2*j-1):(2*j);

N = length(x_cov);
for i = 1:N
    figure(1)
    clf;
    z = zeros(81,81);
    zt = zeros(81,81);
    for j = 1:x_num(i)
        index = calDataRan2(j);
        mean_1 = x_mean{i}(:,j);
        cov_1 = x_cov{i}(:,index);
        zt(k) = mvnpdf([x1(k)',y1(k)'],mean_1',cov_1');
        z = z+zt;
    end
    mesh(x,y,z);
    title('Probability hypothesis density of object');
    xlabel('X axis');        
    ylabel('Y axis');        
    zlabel('Z axis'); 
    pause();
    
    %set(h,'Interpreter','latex');
    
end
