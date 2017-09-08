function [ stater,paramr ] = kf_test(t,state,z, param, previous_t )

%{
%  x,y is the observed value of the ball
%  state should have 4 dimensions [x px y py]
% UNTITLED Summary of this function goes here
%   Four dimensional state: position_x, position_y, velocity_x, velocity_y

    % Place parameters like covarainces, etc. here:
    % P = eye(4)
    % R = eye(2)

    % Check if the first time running this function
    %Q = 10*eye(4);
    %R = 0.005*eye(2);
    
%     if previous_t<0
%         state = [x, 0, y, 0]';
%         param.P = 0.1 * eye(4);
%         predictx = x;
%         predicty = y;
%         return;
%     end
%}   

    dt = t - previous_t;
    A = [1 dt 0 0 ;0 1 0 0 ; 0 0 1 dt;0 0 0 1];
    xp = A*state;
    Pp = A*param.P*A'+param.Q;
    
    H = [1 0 0 0; 0 0 1 0];
    yd = z-H*xp;
    Sk = H*Pp*H' + param.R;
    Kk = Pp*H'/Sk;
    
    stater = xp + Kk*yd;
    paramr.P = Pp - Kk*H*Pp;
    paramr.Q = param.Q;
    paramr.R = param.R;
    
%     % TODO: Add Kalman filter updates
%     % As an example, here is a Naive estimate without a Kalman filter
%     % You should replace this code
%     vx = (x - state(1)) / (t - previous_t);
%     vy = (y - state(2)) / (t - previous_t);
%     % Predict 330ms into the future
%     predictx = x + vx * 0.330;
%     predicty = y + vy * 0.330;

    % State is a four dimensional element
    %state = [x, vx, y, vy];
end
