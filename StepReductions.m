stepreductions = zeros(10,1);
longresults = zeros(10,30);
shortresults = zeros(10,30);

for p = 1:10
    stepreductions(p) = 0.05*(p-1) + 0.5;
    for w = 1:30
        fprintf('THIS IS %d/300\n', (p-1)*30 + w);
        TabuSetup;
        stepreduction = stepreductions(p);
        TabuSearch;
        longresults(p,w) = archive.s_solutions(end).value;
        shortresults(p,w) = shortout;
    end
end