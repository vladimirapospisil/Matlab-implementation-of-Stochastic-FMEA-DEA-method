% compute standard FMEA
clear all

addpath('common')
addpath('problem')
addpath('alg')
addpath('plot')

%% PROBLEM-SPECIFIC STUFF
problem_name = 'test'; % name of output results file
[OSD, minOSD, maxOSD] = problem_test(); % load input OSD values


%% standard FMEA
tic % start to measure time

% normalize OSD (map values to [0,1])
[ OSDn ] = normalize_osd( OSD, minOSD, maxOSD );

% compute RPN as a product of input values
RPN = OSD(:,1).*OSD(:,2).*OSD(:,3);
RPNn = OSDn(:,1).*OSDn(:,2).*OSDn(:,3);

mytime = toc; % stop to measure time

% save results for later use
results_fmea.OSD = OSD; % input data
results_fmea.OSDn = OSDn; % input data
results_fmea.RPN = RPN; % output results
results_fmea.RPNn = RPNn; % output results
results_fmea.mytime = mytime;

% save file
save(['results/' problem_name '_fmea.mat'],'results_fmea')
