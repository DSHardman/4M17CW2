figure()
%%
subplot(2,3,1);
EvolutionSetup
clear temp
temp(mu, 1) = Solution();
for lp = 1:mu
    temp(lp) = copy(startingpoint(lp));
    temp(lp).sigmas = 1*ones(n, 1);
end
parents = Parents(temp);
EvolutionStrategy
ylim([-2000 200]);
%%
subplot(2,3,2);
EvolutionSetup
clear temp
temp(mu, 1) = Solution();
for lp = 1:mu
    temp(lp) = copy(startingpoint(lp));
    temp(lp).sigmas = 5*ones(n, 1);
end
parents = Parents(temp);
EvolutionStrategy
ylim([-2000 200]);
%%
subplot(2,3,3);
EvolutionSetup
clear temp
temp(mu, 1) = Solution();
for lp = 1:mu
    temp(lp) = copy(startingpoint(lp));
    temp(lp).sigmas = 10*ones(n, 1);
end
parents = Parents(temp);
EvolutionStrategy
ylim([-2000 200]);
%%
subplot(2,3,4);
EvolutionSetup
clear temp
temp(mu, 1) = Solution();
for lp = 1:mu
    temp(lp) = copy(startingpoint(lp));
    temp(lp).sigmas = 20*ones(n, 1);
end
parents = Parents(temp);
EvolutionStrategy
ylim([-2000 200]);
%%
subplot(2,3,5);
EvolutionSetup
clear temp
temp(mu, 1) = Solution();
for lp = 1:mu
    temp(lp) = copy(startingpoint(lp));
    temp(lp).sigmas = 40*ones(n, 1);
end
parents = Parents(temp);
EvolutionStrategy
ylim([-2000 200]);
%%
subplot(2,3,6);
EvolutionSetup
clear temp
temp(mu, 1) = Solution();
for lp = 1:mu
    temp(lp) = copy(startingpoint(lp));
    temp(lp).sigmas = 80*ones(n, 1);
end
parents = Parents(temp);
EvolutionStrategy
ylim([-2000 200]);