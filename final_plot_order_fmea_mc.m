clear all

addpath('common')
addpath('problem')
addpath('alg')
addpath('plot')

%% PROBLEM-SPECIFIC STUFF
problem_name = 'test'; % name of input results file (part)
figure_name = 'test_order_sfmea_mc'; % name of output image

% load results
load(['results/' problem_name '_order_fmea_mc.mat']);

%% plot the figure
figure('Position',[0,0,1500,400])
hold on

m = length(results_order_fmea_mc.sigma);
for j = 1:m
    subplot(1,m,j);
    bar3(results_order_fmea_mc.RPN_order_freq{j}',1.0)
    
    title(['$\sigma = ' num2str(results_order_fmea_mc.sigma{j}) '$'],'Interpreter','latex','Fontsize',14);
    
    xlabel('id')
    ylabel('order')
    
end

%view(-120,50);
hold off

% save image
if true
    rez=600; %resolution (dpi) of final graphic
    f=gcf; %f is the handle of the figure you want to export
    figpos=getpixelposition(f); %dont need to change anything here
    resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
    set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
    print(f,['results/' figure_name '.png'],'-dpng',['-r',num2str(rez)],'-opengl') %save file
end



