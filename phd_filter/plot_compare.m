close all 
clear
clc
load data.mat
load result.mat
pos_real = [0,1;1,0];
N = length(x_cov);
for i = 1:N-1
    figure(1)
    clf;
    scatter(pos_real(1,:),pos_real(2,:),'d','r');
    hold on
    detect = z_ob{i};
    scatter(detect(1,:),detect(2,:),'o','b');
    hold on
    est = x_mean{i+1};
    scatter(est(1,:),est(2,:),'x','b');
    axis([-10,10,-10,10]);
    xlabel('X');        
    ylabel('Y');
    pause(1);
end