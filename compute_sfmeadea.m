% compute stochastic FMEA-DEA
clear all

addpath('common')
addpath('problem')
addpath('alg')
addpath('plot')

%% PROBLEM-SPECIFIC STUFF
problem_name = 'test'; % name of output results file
[OSD, minOSD, maxOSD] = problem_test(); % load input OSD values

sigma_OSD = 0.05*ones(size(OSD)); % noise parameter
beta_s = 0.5*ones(size(OSD,1),1);
alpha_s = 0.01*ones(size(OSD,1),1);
x0 = 0.5*ones(5,1); % initial approximation for stochastic dea


%% stochastic FMEA-DEA
tic % start to measure time

% normalize OSD (map values to [0,1])
[ OSDn ] = normalize_osd( OSD, minOSD, maxOSD );

% run the algorithm 
[values] = stochastic_dea( OSDn, sigma_OSD, beta_s, alpha_s, x0 );

mytime = toc; % stop to measure time

% save results for later use
results_sfmeadea.OSD = OSD; % problem values
results_sfmeadea.OSDn = OSDn; % normalized problem values
results_sfmeadea.sigma_OSD = sigma_OSD; 
results_sfmeadea.beta_s = beta_s;
results_sfmeadea.alpha_s = alpha_s; 
results_sfmeadea.x0 = x0; 
results_sfmeadea.values = values; % results
results_sfmeadea.mytime = mytime; 

% save file
save(['results/' problem_name '_sfmeadea.mat'],'results_sfmeadea')
