subplot(4,2,1); ax = gca; hold on
for w = 1:3
    TabuSetup;
    LS = 'Exhaustive';
    basepoint = Basepoint(zeros(n,1), stepsize);
    TabuSearch;
end

subplot(4,2,3); ax = gca; hold on
for w = 1:3
    TabuSetup;
    LS = 'RandomSubset';
    basepoint = Basepoint(zeros(n,1), stepsize);
    basepoint.setNsubsets(5);
    TabuSearch;
end

subplot(4,2,5); ax = gca; hold on
for w = 1:3
    TabuSetup;
    LS = 'RandomSubset';
    basepoint = Basepoint(zeros(n,1), stepsize);
    basepoint.setNsubsets(2);
    TabuSearch;
end

subplot(4,2,7); ax = gca; hold on
for w = 1:3
    TabuSetup;
    LS = 'VariablePrioritisation';
    basepoint = Basepoint(zeros(n,1), stepsize);
    basepoint.setPrioritisation(5);
    TabuSearch;
end

%%
subplot(4,2,2); ax = gca; hold on
for w = 1:3
    TabuSetup;
    LS = 'Exhaustive';
    x = [-308.1; 63.6; 289.6; 174.3; -356.3];
    basepoint = Basepoint(x, stepsize);
    TabuSearch;
end

subplot(4,2,4); ax = gca; hold on
for w = 1:3
    TabuSetup;
    LS = 'RandomSubset';
    x = [-308.1; 63.6; 289.6; 174.3; -356.3];
    basepoint = Basepoint(x, stepsize);
    basepoint.setNsubsets(5);
    TabuSearch;
end

subplot(4,2,6); ax = gca; hold on
for w = 1:3
    TabuSetup;
    LS = 'RandomSubset';
    x = [-308.1; 63.6; 289.6; 174.3; -356.3];
    basepoint = Basepoint(x, stepsize);
    basepoint.setNsubsets(2);
    TabuSearch;
end

subplot(4,2,8); ax = gca; hold on
for w = 1:3
    TabuSetup;
    LS = 'VariablePrioritisation';
    x = [-308.1; 63.6; 289.6; 174.3; -356.3];
    basepoint = Basepoint(x, stepsize);
    basepoint.setPrioritisation(5);
    TabuSearch;
end