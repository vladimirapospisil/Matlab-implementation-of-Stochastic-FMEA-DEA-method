clear all

%% PROBLEM-SPECIFIC STUFF
problem_name = 'test'; % name of input results file (part)
figure_name = 'test_fmeadea'; % name of output image

% load results
load(['results/' problem_name '_fmeadea.mat']);

%% plot the figure
myfsize = 15; % fontsize

myfig = figure;
set(gca,'fontsize',myfsize);

OSD = results_fmeadea.OSD;
values = results_fmeadea.values;
% maybe some values are larger than 1 because of numerical error?
values = min(max(values,0),1);

hold on

% create colormap
mymap = redgreencmap(100);

for i=1:size(OSD,1)
    idx_color = floor(100*values(i));
    
    plot3(OSD(i,1),OSD(i,2),OSD(i,3),'rs','MarkerSize',10, ...
        'MarkerEdgeColor',[0,0,0], ...
        'MarkerFaceColor',mymap(idx_color,:))

end
    
grid on
 set(gca,'xtick',1:5)
 set(gca,'ytick',1:5)
 set(gca,'ztick',1:5)
axis([1 5 1 5 1 5])

xlabel('Occurrence')
ylabel('Severity')
zlabel('Detection')

colormap(mymap);
c = colorbar('Ticks',0:0.2:1);
c.Label.String = 'Hazard level';     

view(-20,30)
hold off

% save image
if false
set(myfig, 'Position', [7.4000   46.6000  681.6000  736.0000])
print(gcf,['results/' figure_name '.png'],'-dpng','-r600');
end