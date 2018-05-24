function plot_bar3_hist( M_order, save_or_not, filename )
% vykresli 3d histogram poradia scenarov

figure('Position',[0,0,1000,1000])
hold on

bar3(M_order',1.0)

view(-120,50);
hold off

if save_or_not
    rez=600; %resolution (dpi) of final graphic
    f=gcf; %f is the handle of the figure you want to export
    figpos=getpixelposition(f); %dont need to change anything here
    resolution=get(0,'ScreenPixelsPerInch'); %dont need to change anything here
    set(f,'paperunits','inches','papersize',figpos(3:4)/resolution,'paperposition',[0 0 figpos(3:4)/resolution]); %dont need to change anything here
    path=filename; %the folder where you want to put the file
    print(f,path,'-dpng',['-r',num2str(rez)],'-opengl') %save file
end


end

