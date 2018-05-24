clear all

addpath('common')
addpath('problem')
addpath('alg')
addpath('plot')

%% PROBLEM-SPECIFIC STUFF
problem_name = 'test'; % name of input results file (part)
[OSD, minOSD, maxOSD] = problem_test(); % load input OSD values

% input parameters for Monte Carlo sampling
sigma = {0.5, 0.05, 0.0};
n_mc = 1e4; % number of Monte Carlo samples

%% perform mc sampling
tic % start to measure time

[ OSDn ] = normalize_osd( OSD, minOSD, maxOSD );

n = size(OSD,1); % number of scenario
m = length(sigma); % number of sigmas

% generate random values of OSD
disp(' - monte carlo sampling')
O_noise = cell(m,1);
S_noise = cell(m,1);
D_noise = cell(m,1);
for j=1:m
    % generate random values
    O_noise{j} = zeros(n,n_mc);
    S_noise{j} = zeros(n,n_mc);
    D_noise{j} = zeros(n,n_mc);
    for i=1:n
        O_noise{j}(i,:) = OSDn(i,1) + sigma{j}*randn(1,n_mc);
        S_noise{j}(i,:) = OSDn(i,2) + sigma{j}*randn(1,n_mc);
        D_noise{j}(i,:) = OSDn(i,3) + sigma{j}*randn(1,n_mc);
    end
    
end


RPN_noise = cell(m,1);
RPN_order = cell(m,1);
for j = 1:m
    RPN_noise{j} = zeros(n,n_mc);
    RPN_order{j} = zeros(n,n_mc);
end
c = zeros(n,1);

RPN_order_freq = cell(m,1);

% compute RPN and order
disp(' - computing order')
for j = 1:m
    for i = 1:n_mc
        % compute RPN
        RPN_noise{j}(:,i) = O_noise{j}(:,i).*S_noise{j}(:,i).*D_noise{j}(:,i);
        
        % sort rpn
        [~,idx] = sort(RPN_noise{j}(:,i),1,'descend');
        c(idx)= 1:n;
        
        % save order
        RPN_order{j}(:,i) = c;
    end
    
    % compute frequencies
    RPN_order_freq{j} = zeros(n,n);
    for k = 1:n
        for l = 1:n
            RPN_order_freq{j}(k,l) = sum(RPN_order{j}(k,:) == l);
        end
    end
end

mytime = toc; % stop to measure time


% save results for later use
results_order_fmea_mc.OSD = OSD; % problem values
results_order_fmea_mc.sigma = sigma;
results_order_fmea_mc.n_mc = n_mc;
results_order_fmea_mc.O_noise = O_noise; % O with noise
results_order_fmea_mc.S_noise = S_noise; % S with noise
results_order_fmea_mc.D_noise = D_noise; % D with noise
results_order_fmea_mc.RPN_noise = RPN_noise;
results_order_fmea_mc.RPN_order = RPN_order;
results_order_fmea_mc.RPN_order_freq = RPN_order_freq;
results_order_fmea_mc.mytime = mytime;

% save file
save(['results/' problem_name '_order_fmea_mc.mat'],'results_order_fmea_mc')



