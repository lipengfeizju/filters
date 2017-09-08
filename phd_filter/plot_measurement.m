close all 
clear
clc
load data.mat
load result.mat

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
    xlabel('X÷·');        
    ylabel('Y÷·');        
    zlabel('Z÷·'); 
    pause();
end
%z(k) = mvnpdf([x1(k)',y1(k)'],mean1,cov);

      