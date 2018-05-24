clear all

%% PROBLEM-SPECIFIC STUFF
problem_name = 'test'; % name of input results file (part)

% load results
load(['results/' problem_name '_fmea.mat']);
load(['results/' problem_name '_fmea_mc.mat']);
load(['results/' problem_name '_fmeadea.mat']);
load(['results/' problem_name '_fmeadea_mc.mat']);
load(['results/' problem_name '_sfmeadea.mat']);

%% display latex table
for i=1:size(results_fmea.OSD,1)
    % write O,S,D
    myrow = [num2str(results_fmea.OSD(i,1)) ' & ' num2str(results_fmea.OSD(i,2)) ' & ' num2str(results_fmea.OSD(i,3)) ' & ' ];

    % write RPN from FMEA
    myrow = [myrow num2str(results_fmea.RPN(i)) ' & '];

    % write results from deterministic dea
    myrow = [myrow num2str(results_fmeadea.values(i)) ' & '];
    
    % write results from stochastic dea
    myrow = [myrow num2str(results_sfmeadea.values.mu(i)) ' \\ \hline'];
    
    disp(myrow)
end
