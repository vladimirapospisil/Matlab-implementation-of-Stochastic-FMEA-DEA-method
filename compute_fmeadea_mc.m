% compute deterministic FMEA-DEA with monte carlo noise sampling
clear all

addpath('common')
addpath('problem')
addpath('alg')
addpath('plot')

%% PROBLEM-SPECIFIC STUFF
problem_name = 'test'; % name of output results file
[OSD, minOSD, maxOSD] = problem_test(); % load input OSD values

sigma_OSD = 0.05*ones(size(OSD)); % parameter of the noise
n_mc = 1e4; % number of generated problems for Monte Carlo


%% deterministic FMEA-DEA for every MC sample
tic % start to measure time

% normalize OSD (map values to [0,1])
[ OSDn ] = normalize_osd( OSD, minOSD, maxOSD );

% generate random values
O_noise = zeros(size(OSDn,1),n_mc);
S_noise = zeros(size(OSDn,1),n_mc);
D_noise = zeros(size(OSDn,1),n_mc);
for i=1:size(OSDn,1)
    O_noise(i,:) = OSDn(i,1) + sigma_OSD(i,1)*randn(1,n_mc);
    S_noise(i,:) = OSDn(i,2) + sigma_OSD(i,2)*randn(1,n_mc);
    D_noise(i,:) = OSDn(i,3) + sigma_OSD(i,3)*randn(1,n_mc);
end

% solve deterministic problem for each random realisation
values = zeros(size(OSD,1),n_mc);
for i=1:n_mc
    if mod(i,5) == 0
        disp(['Monte Carlo i=' num2str(i) ' of ' num2str(n_mc) ]);
    end
    values(:,i) = deterministic_dea([O_noise(:,i),S_noise(:,i),D_noise(:,i)]);
end

mytime = toc; % stop to measure time

% save results for later use
results_fmeadea_mc.OSD = OSD; % problem values
results_fmeadea_mc.OSDn = OSDn; % normalized problem values
results_fmeadea_mc.sigma_OSD = sigma_OSD;
results_fmeadea_mc.n_mc = n_mc;
results_fmeadea_mc.O_noise = O_noise; % O with noise
results_fmeadea_mc.S_noise = S_noise; % S with noise
results_fmeadea_mc.D_noise = D_noise; % D with noise
results_fmeadea_mc.values = values; % results
results_fmeadea_mc.mytime = mytime;

% save file
save(['results/' problem_name '_fmeadea_mc.mat'],'results_fmeadea_mc')
