function compare_mcddea_sdea( results_ddea, results_sdea )

% number of scenarios
m = size(results_ddea,1);

figure
for i=1:m
    subplot(m,1,i)
    hold on
    
    % plot deterministic DEA
    [Nhist,Xhist] = hist(results_ddea(i,:),0:0.005:1);

    % plot histogram
    diff = (Xhist(2)-Xhist(1))/2;
    for j=1:length(Nhist)
        v = Nhist(j)/max(Nhist);
        fill([Xhist(j)-diff Xhist(j)+diff Xhist(j)+diff Xhist(j)-diff], [0 0 v v], 'b')
    end

    % plot stochastic results
    if true
        random_values_sdea = results_sdea.mu(i) + results_sdea.sigma(i)*randn(1,1000000);
        [Nhist2,Xhist2] = hist(random_values_sdea,0.001:0.001:1);
        plot(Xhist2, Nhist2/max(Nhist2), 'r');
    end
    
    axis([0-diff 1+diff 0 inf])
    hold off
end


end

