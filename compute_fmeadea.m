% compute deterministic FMEA-DEA
clear all

addpath('common')
addpath('problem')
addpath('alg')
addpath('plot')

%% PROBLEM-SPECIFIC STUFF
problem_name = 'test'; % name of output results file
[OSD, minOSD, maxOSD] = problem_test(); % load input OSD values


%% deterministic FMEA-DEA
tic % start to measure time

% normalize OSD (map values to [0,1])
[ OSDn ] = normalize_osd( OSD, minOSD, maxOSD );

% solve problem for given OSDn
values = deterministic_dea(OSDn);

mytime = toc; % stop to measure time

% save results for later use
results_fmeadea.OSD = OSD; % problem values
results_fmeadea.OSDn = OSDn; % normalized problem values
results_fmeadea.values = values; % results
results_fmeadea.mytime = mytime; 

% save file
save(['results/' problem_name '_fmeadea.mat'],'results_fmeadea')
