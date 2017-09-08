%implement the GM-PHD filter
%This is a static map so the birth probability and the spawn probability is zero
%the survival probability should be one 
%the detection probability can be adjusted 
%we can have two param in the state vector

function [ob_numr, ob_weightr, ob_meanr , ob_covr] = phd_filter(ob_num, ob_weight, ob_mean , ob_cov, z_num, z_mean )
%param determines in here
prob_survival = 1 ;
prob_detection = 0.85;   %0.9 best
kapa_k = 0.005;
%we can adjust the prune and merge parameter if needed
T = 1e-4;%the minimum probability   1e-3 best
state_num = 2;%we only use the two param in the vector
F = eye(state_num);%if we only consider the position excluding the velocity
H = eye(state_num);%if we don't observe the velocity
Q = 0*eye(state_num);R = 0.1*eye(state_num);%the noise that added to the model
dm = 5;%the max distance that we don't merge two objects  5 best


%Used to calculate the indices of two-dimensional target j in a long list of two-dimensional targets
calDataRan2 = @(j) (2*j-1):(2*j);
%step1 ignore since there is no birth probability
%step2 predict for existing targets

we_pred = prob_survival*ob_weight;
%allocate memory first
mean_pred = zeros(state_num,ob_num);
cov_pred = zeros(state_num, state_num * ob_num);

for j = 1:ob_num
	mean_pred(:,j) = F*ob_mean(:,j);
	index = calDataRan2(j);
	cov_pred(:,index) = F*ob_cov(:,index)*F'+Q;
end
%step3 construct of PHD update components
eta = zeros(state_num,ob_num); re_cov = zeros(state_num,ob_num);
K = zeros(state_num, state_num * ob_num); cov_next = zeros(state_num, state_num * ob_num);

for j = 1:ob_num
	eta(:,j) = H*mean_pred(:,j);%the expected observation 
	index = calDataRan2(j);
	re_cov(:,index) = R+H*cov_pred(:,index)*H';%the covaraince of the residual
	K(:,index) = cov_pred(:,index)*H'/re_cov(:,index);%calculate the Kalman Gain
	cov_next(:,index) = cov_pred(:,index) - K(:,index)*H*cov_pred(:,index);
end

%step4 update the system with the measurement
we_pred = (1- prob_detection)*we_pred;
omega = zeros(1,z_num*ob_num);
mean_2 = zeros(state_num,z_num*ob_num);
P2 = zeros(state_num,state_num*z_num*ob_num);
%update the new weight
for j = 1:z_num
	temp = 0;
	for i = 1:ob_num
		index1 = calDataRan2((j-1)*ob_num+i);
		omega(:,(j-1)*ob_num+i) =  prob_detection*mvnpdf(z_mean(:,j),eta(:,i),re_cov(:,index));
		temp = temp+omega(:,(j-1)*ob_num+i);
        index2 = calDataRan2(i);%calculate the index
		mean_2(:,(j-1)*ob_num+i) = mean_pred(:,i) + K(:,index2)*(z_mean(:,j) - eta(:,i));		
		P2(:,index1) = cov_next(:,index2);		
	end
	omega(1,((j-1)*ob_num+1):(j*ob_num)) = omega(1,((j-1)*ob_num+1):(j*ob_num)) /(kapa_k+temp);
	%omega(2,((j-1)*ob_num+1):((j-1)*ob_num+z_num)) = omega(2,((j-1)*ob_num+1):((j-1)*ob_num+z_num))/(kapa_k+temp(2));
end
%combine the results
	we_update = [we_pred, omega];
	mean_update = [mean_pred,mean_2];
	cov_update = [cov_next,P2];
	total = sum(we_update) ;
	we_update= we_update/total; % we_update(2,:) = we_update(2,:)/total(2);
%do the pruning and merging

I = find(we_update >= T);
ob_weightr = [];
ob_meanr = [];
ob_covr = [];
while isempty(I) == false
	highWeights = we_update(:,I);
    [~, j] = max(highWeights);
    j = j(1);
    delete_i = [];
    tmp = mean_update(:,I(j));
    P_tmp = zeros(state_num);
    mean_tmp = zeros(state_num,1);
    for i = 1:length(I)
    	index1 = calDataRan2(I(i));
    	P1 = cov_update(:,index1);
    	m1 = mean_update(:,I(i));
    	dis = (tmp-m1)'/P1*(tmp-m1);
    	if dis<dm
    		delete_i = [delete_i, i]; %#ok<AGROW>
    		%calculate the covariance
            index = calDataRan2(I(i));
    		P_tmp = P_tmp + we_update(I(i))*((tmp-m1)'*(tmp-m1) + cov_update(:,index));
            mean_tmp = mean_tmp + we_update(I(i)) * mean_update(:,I(i));
    	end
    end
    weight1 = sum(we_update(I(delete_i)));
    mean1 = mean_tmp/weight1;
    P_tmp = P_tmp/weight1;
    
    ob_weightr = [ob_weightr, weight1];%#ok<AGROW>
    ob_meanr = [ob_meanr, mean1];%#ok<AGROW>
   	ob_covr = [ob_covr, P_tmp];%#ok<AGROW>

   	I(delete_i) = [];
end
ob_numr = length(ob_weightr);
end