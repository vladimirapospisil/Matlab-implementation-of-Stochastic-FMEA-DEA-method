clear all

%% PROBLEM-SPECIFIC STUFF
problem_name = 'test'; % name of input results file (part)
figure_name = 'test_sfmeadea'; % name of output image

% load results
%load(['results/' problem_name '_fmea.mat']);
%load(['results/' problem_name '_fmea_mc.mat']);
load(['results/' problem_name '_fmeadea.mat']);
load(['results/' problem_name '_fmeadea_mc.mat']);
load(['results/' problem_name '_sfmeadea.mat']);

%% plot the figure
myfsize = 15; % fontsize

myfig = figure;
set(gca,'fontsize',myfsize);

what_to_plot = size(results_sfmeadea.values.mu,1);
for i=1:what_to_plot
    subplot(what_to_plot,2,2*(i-1)+1)
    hold on
    
    % plot deterministic FMEA-DEA with MC
    [Nhist,Xhist] = hist(results_fmeadea_mc.values(i,:),0:0.005:1);
    
    % plot histogram
    diff = (Xhist(2)-Xhist(1))/2;
    for j=1:length(Nhist)
        v = Nhist(j)/max(Nhist);
        h = fill([Xhist(j)-diff Xhist(j)+diff Xhist(j)+diff Xhist(j)-diff], [0 0 v v], 'b');
        set(h,'EdgeColor','none');
    end
    
    % plot deterministic dea
    h = fill([results_fmeadea.values(i)-diff results_fmeadea.values(i)+diff results_fmeadea.values(i)+diff results_fmeadea.values(i)-diff], [0 0 1 1], 'r');
    set(h,'EdgeColor','none');
    
    
    %    axes('Color','none','YColor','none');
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    set(gca,'xtick',0:0.25:1);
    if i < what_to_plot
        set(gca,'xticklabel',[])
    else
        myxtick = get(gca,'xticklabel');
        
        myxtick{2} = '';
        myxtick{4} = '';
        
        set(gca,'xticklabel',myxtick)
        
    end
    grid on
    
    axis([0-diff 1+diff 0 1])
    hold off
    
    
    % stochastic
    subplot(what_to_plot,2,2*i)
    hold on
    
    random_values_sdea = results_sfmeadea.values.mu(i) + results_sfmeadea.values.sigma(i)*randn(1,1000000);
    [Nhist2,Xhist2] = hist(random_values_sdea,0.001:0.001:1);
    plot(Xhist2, Nhist2/max(Nhist2), 'r');
    
    set(gca,'ytick',[])
    set(gca,'yticklabel',[])
    
    set(gca,'xtick',[0:0.25:1.0]*max(results_sfmeadea.values.mu))
    
    if i < what_to_plot
        %           set(gca,'xtick',[])
        set(gca,'xticklabel',[])
    else
        myxtick = get(gca,'xticklabel');
        
        myxtick{2} = '';
        myxtick{4} = '';
        
        set(gca,'xticklabel',myxtick)
        
    end
    
    grid on
    
    axis([0-diff max(results_sfmeadea.values.mu)+diff 0 1])
    hold off
end


set(myfig, 'Position', [7.4000   46.6000  681.6000  736.0000])
print(gcf,['results/' figure_name '.png'],'-dpng','-r600');
