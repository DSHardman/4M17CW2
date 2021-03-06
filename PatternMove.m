subplot(2,2,1); ax = gca; hold on
for w = 1:3
    TabuSetup;
    PM = 'Single';
    basepoint = Basepoint(zeros(n,1), stepsize);
    TabuSearch;
end

subplot(2,2,3); ax = gca; hold on
for w = 1:3
    TabuSetup;
    PM = 'Indefinite';
    basepoint = Basepoint(zeros(n,1), stepsize);
    TabuSearch;
end

%%
subplot(2,2,2); ax = gca; hold on
for w = 1:3
    TabuSetup;
    PM = 'Single';
    x = [-308.1; 63.6; 289.6; 174.3; -356.3];
    basepoint = Basepoint(x, stepsize);
    TabuSearch;
end

subplot(2,2,4); ax = gca; hold on
for w = 1:3
    TabuSetup;
    PM = 'Indefinite';
    x = [-308.1; 63.6; 289.6; 174.3; -356.3];
    basepoint = Basepoint(x, stepsize);
    TabuSearch;
end