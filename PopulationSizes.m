lambdas = 40:10:120;
mus = 5:5:40;
avresults = zeros(9,8);
bestresults = zeros(9,8);

for w = 1:9
    for q = 1:8
        fprintf('OPT %d/72\n', (w-1)*8+q);
        EvolutionSetup
        lambda = lambdas(w);
        mu = mus(q);
        temp = randsample(startingpoint, mu);
        clear temp2
        temp2(mu, 1) = Solution();
        for lp = 1:mu
            temp2(lp) = copy(temp(lp));
        end
        parents = Parents(temp2);
        try
            EvolutionStrategy
            sum = 0;
           
            for po = 1:length(archive.d_solutions)
                sum = sum + archive.d_solutions(po).value;
            end
            avresults(w,q) = sum/length(archive.d_solutions);
            bestresults(w,q) = archive.s_solutions(end).value;
            fprintf('Allocating %f...\n', archive.s_solutions(end).value);
        catch
            fprintf('Failed: Allocating NaN...\n');
            avresults(w,q) = NaN;
            bestresults(w,q) = NaN;
        end
    end
end