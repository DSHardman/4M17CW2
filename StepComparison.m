stepcompare = zeros(10,2);
for w = 1:10
    fprintf('Comparison: %d\n', w);
    TabuSetup;
    stepsize = 10*w;
    TabuSearch;
    stepcompare(w,:) = [stepsize archive.s_solutions(end).value];
end