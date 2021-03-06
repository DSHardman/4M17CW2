muvalues = {'5','10','15','20','25','30','35','40'};
lambdavalues = {'120', '110', '100', '90', '80', '70', '60', '50', '40'};

figure()
subplot(1,2,1);
heatmap(muvalues, lambdavalues, flipud(avresults));
colormap(flipud(gray));
xlabel('\mu');
ylabel('\lambda');
set(gca, 'FontSize', 12);
colorbar('off');

subplot(1,2,2);
heatmap(muvalues, lambdavalues, flipud(bestresults));
colormap(flipud(gray));
xlabel('\mu');
ylabel('\lambda');
set(gca, 'FontSize', 12);
colorbar('off');