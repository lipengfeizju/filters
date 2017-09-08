clear;
close all;
T = 1000;
dx = 4;
x0 = zeros(dx,1);


dt = 0.001;
A = [1 dt dt^2/2 dt^3/6;
     0 1 dt dt^2/2
     0 0 1 dt
     0 0 0 1];%sta  te transition model
B = [5*dt^4/8; 7*dt^3/6; 3*dt^2/2; dt];% control-input model 

sgm  = 10;
Q = 10*eye(1) * sgm^2; % process noise
Q = [ (dt^7*Q)/252, (dt^6*Q)/72, (dt^5*Q)/30, (dt^4*Q)/24;
      (dt^6*Q)/72, (dt^5*Q)/20,  (dt^4*Q)/8,  (dt^3*Q)/6;
      (dt^5*Q)/30,  (dt^4*Q)/8,  (dt^3*Q)/3,  (dt^2*Q)/2;
      (dt^4*Q)/24,  (dt^3*Q)/6,  (dt^2*Q)/2,        dt*Q];
R = 10*eye(dx) * sgm^2; % measurement covariance


H = eye(dx); % H = [1 0 0 0];

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
% simulate continuous system
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%
Ts   = 0:dt:1;          	%
Ac    = [0 1 0 0;            % State transition matrix
        0 0 1 0;
        0 0 0 1;
        0 0 0 0];
Bc    = [0; 0; 0; 1];
[Ts, XS] = ode45(@(t,x) noisy_model(t, x, Ac, Bc, sgm), Ts, x0); % Solve ODE
XS = XS';
XSMax = max(XS, [], 2);
z(1,:) = XS(1,2:end) + 0.05*randn(size(XS(1,2:end)))*XSMax(1);
z(2,:) = XS(2,2:end) + 0.1*randn(size(XS(1,2:end)))*XSMax(2);
z(3,:) = XS(3,2:end) + 0.15*randn(size(XS(1,2:end)))*XSMax(3);
z(4,:) = XS(4,2:end) + 0.2*randn(size(XS(1,2:end)))*XSMax(4);
%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%


% kalman filter
m0 = x0;
P0 = eye(dx);

m = zeros(dx,T+1);
%y = zeros(ds,T+1);%measurement residual
P = zeros(dx,dx,T+1);
m(:,1) = m0;
P(:,:,1) = P0;

for k = 1:T
    u = input_fun(k*dt);
    
    % TODO: Implement mean_p, riccati_p, mean_e, riccati_e
    m(:,k+1) = mean_p(m(:,k),A,B,u);
    P(:,:,k+1) = riccati_p(P(:,:,k),A,Q);
    
    %update
    y = z(:,k)-H*m(:,k);
    S = H*P(:,:,k+1)*H'+ R;
    K = P(:,:,k+1)*H/S;%K = P(:,:,k+1)*H*inv(S);
    
    
    % measurement
    m(:,k+1) = mean_e(m(:,k+1),y,K);
    P(:,:,k+1) = riccati_e(P(:,:,k+1),H,K);
end

%%% Figures
%{
figure(1); hold on; grid on;
plot(Ts, XS(1, :), 'r');
plot(Ts, XS(2, :), 'g');
plot(Ts, XS(3, :), 'b');
plot(Ts, XS(4, :), 'c');
plot(Ts, input_fun(Ts), 'm');
h = legend('$x$', '$x^{(i)}$', '$x^{(ii)}$', '$x^{(iii)}$', 'u', 'Location', 'NorthWest');
set(h,'Interpreter','latex');
set(h,'FontSize', 16);
xlabel('Time (seconds)');
title('Model Simulation');

%}
%set(0,'DefaultAxesColorOrder',[0.1,0.4,0.6]);
figure(2); hold on; 
subplot(221);
plot(Ts, XS(1, :), Ts(2:end), z(1, :), Ts, m(1,:),'g');
h = legend('$x$', '$z$','$\hat{x}$','Location', 'NorthWest');
set(h,'Interpreter','latex');
set(h,'FontSize', 16);
xlabel('Time (seconds)');
title('Sensed Information (Position)');
grid on;

%figure; 
hold on;
subplot(222);
plot(Ts, XS(2, :), Ts(2:end), z(2, :), Ts, m(2,:),'g');
h = legend('$\dot{x}$', '$\dot{z}$','$\hat{\dot{x}}$','Location', 'NorthWest');
set(h,'Interpreter','latex');
set(h,'FontSize', 16);
xlabel('Time (seconds)');
title('Sensed Information (Velocity)');
grid on;
 
%figure;
hold on;
subplot(223);
plot(Ts, XS(3, :), Ts(2:end), z(3, :), Ts, m(3,:),'g');
h = legend('$\ddot{x}$', '$\ddot{z}$','$\hat{\ddot{x}}$','Location', 'NorthWest');
set(h,'Interpreter','latex');
set(h,'FontSize', 16);
xlabel('Time (seconds)');
title('Sensed Information (Acceleration)');
grid on;

%figure; 
hold on;
subplot(224);
plot(Ts, XS(4, :), Ts(2:end), z(4, :),Ts, m(4,:), 'g');
h = legend('${x}^{(3)}$', '${z}^{(3)}$','${\hat{x}}^{(3)}$','Location', 'NorthWest');
set(h,'FontSize', 16);
set(h,'Interpreter','latex');
xlabel('Time (seconds)');
title('Sensed Information (Jerk)');
grid on;

hold off


