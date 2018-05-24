function plot_mc_distf( M_order, n_MC )

% pocet scenarov
m = size(M_order,1);

% predpokladajme normalne rozdelenie vysledkov
means = zeros(m,1); % stredna hodnota
sigmas = zeros(m,1); % smerodatna odchylka
for i = 1:m
    orders = (M_order(i,:)/n_MC).*[1:m];
    means(i) = mean(orders*m);
    sigmas(i) = std(orders);
end

% vykresli distribucne funkcie
figure
hold on
xs = 1:.01:m;
for i=1:m
    pdfs = normpdf(xs,means(i),sigmas(i));
    plot(xs,pdfs);
    mylegend{i} = num2str(i);
end
legend(mylegend);

end

