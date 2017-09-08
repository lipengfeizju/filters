close all;
clear;
N = 200;
t = 0.005*(1:N);
x1 = normrnd(0,0.1,[1,N])+1;
y1 = normrnd(0,0.1,[1,N])+0;
x0 = 1.5;  y0 = 0.7;
x2 = normrnd(0,0.1,[1,N])+0;
y2 = normrnd(0,0.1,[1,N])+1;

last_t = -1;
myPredictions1 = zeros(2, N);
myPredictions2 = zeros(2, N);
P1 = zeros(1,N);P2 = zeros(1,N);
param1 = {};param2 = {};

for i=1:N
     if i == 1
        state1 = [x0, y0]';
        state2 = [x0, 0, y0, 0]';
        param1.P = 1 * eye(2);  param1.Q = 0*eye(2); param1.R = 0.5*eye(2); %the object doesn't move
        param2.P = 1 * eye(4);  param2.Q = 0*eye(4); param2.R = 1*eye(2); %the object moves
        myPredictions1(:,i) = [state1(1),state1(2)]';
        myPredictions2(:,i) = [state2(1),state2(3)]';
     else
         z1 = [x1(i);y1(i)];
         z2 = [x1(i);y1(i)];
         if (numel(state1)~=2 )|| (numel(state2)~=4 )
               error('Your state may have false dimensions.');
         end
         [state1,param1] = kf_test1(state1,z1,param1);%2 parameter vector
         [state2,param2] = kf_test(t(i),state2,z2,param2,last_t);%4 parameter vector
         myPredictions1(:,i) = [state1(1),state1(2)]';
         myPredictions2(:,i) = [state2(1),state2(3)]';
         P1(i) = trace(param1.P);
         P2(i) = trace(param2.P);
%          scatter(z1(1),z1(2),10,'b');
%          hold on
%          scatter(state1(1),state1(3),10,'r');
%          hold on
%          scatter(z2(1),z2(2),10,'d','b');
%          hold on
%          scatter(state2(1),state2(3),10,'d','r');
%          hold on
         %for j = 1:100000000
          %   tmp = 1;
         %end
     end
    %[ px, py, state, param ] = kalmanFilter( t(i),state, param, last_t);
    last_t = t(i);

%     myPredictions(1, i) = px;
%     myPredictions(2, i) = py;
end

kf_plot;



