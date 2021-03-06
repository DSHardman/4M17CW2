subplot(1,2,1); ax = gca; hold on
TabuSetup;
PM = 'Single';
for w = 1:3
    basepoint = Basepoint(zeros(n,1), stepsize);
    TabuSearch;
end

subplot(1,2,2); ax = gca; hold on
TabuSetup;
PM = 'Indefinite';
for w = 1:3
    basepoint = Basepoint(zeros(n,1), stepsize);
    TabuSearch;
end