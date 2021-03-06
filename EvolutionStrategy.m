EvolutionSetup

evaluations = 0; % Total number of function evaluations performed
g = 0; % Number of generations so far

while evaluations < maxevaluations
    g = g + 1;
    
    % Plot progress live for 2D case
    if n == 2
        subplot(2,2,4)
        for i = 1:parents.mu
            hold on
            scatter(ax, parents.solutions(i).x(1),...
                parents.solutions(i).x(2), 5, 'k', 'filled');
        end
        pause(0.01);
    end
    
    % Mutate and recombine
    parents.mutateAll(tau, tau_dash, beta);
    offspring = parents.recombine(lambda, 'Discrete', 'Intermediate');
    evaluations = offspring.evaluateAll(evaluations);
    % Update archive
    archive.update(offspring);
    
    if offspring.halt(epsilon_c)
        fprintf('Stopping Criterion Achieved\n');
        return
    end

    % Selection of next population
    %fprintf('Generating Population %d\n', g+1);
    parents = offspring.select(mu, parents, sel);
    
end

fprintf('Maximum Number of Evaluations Reached\n');