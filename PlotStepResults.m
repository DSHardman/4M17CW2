figure('Position', [100 100 1000 500]); hold on;
for i = 1:10
    for j = 1:30
        scatter(stepreductions(i), shortresults(i,j), 10, 'k', 'x');
        scatter(stepreductions(i), longresults(i,j), 10, 'k', 'filled');
    end
end

plot(stepreductions, median(shortresults')', 'Color', 'k', 'LineStyle', '--');
plot(stepreductions, median(longresults')', 'Color', 'k');
xlabel('r');
ylabel('Best f(x)');
legend({'1,000 Evaluations','10,000 Evaluations'});
set(gca, 'FontSize', 12, 'LineWidth', 1.5);