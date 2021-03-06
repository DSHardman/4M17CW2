TabuSetup

counter = 0; % Iterations since best solution was found
evaluations = 0; % Total number of function evaluations performed
i = 0; % Number of iterations so far

while evaluations < maxevaluations
    i = i + 1;
    
    % Display updates
    if rem(i,100) == 0
        fprintf('Iteration: %d\n', i)
        if n == 2 
            pause(0.01); % Allows 2D plot to update
        end
    end
    
    % Update memories & archive
    updatememory(stm, mtm, ltm, basepoint.solution);
    archive.update(basepoint.solution);
    
    if n == 2 % Plot progress live for 2D case
        scatter(ax, basepoint.solution.x(1),...
            basepoint.solution.x(2), 10, 'k', 'filled');
        if i < 50
        scatter(ax1, basepoint.solution.x(1),...
            basepoint.solution.x(2), 10, 'k', 'filled');
        end
        if i < 501 && i > 450
        scatter(ax3, basepoint.solution.x(1),...
            basepoint.solution.x(2), 10, 'k', 'filled');
        end
        if i < 276 && i > 225
        scatter(ax2, basepoint.solution.x(1),...
            basepoint.solution.x(2), 10, 'k', 'filled');
        end
    end
    
    if basepoint.quitSearch(epsilon)
        fprintf('Stopping Critereon Achieved\n');
        return
    end
    
    % Perform local search iteration
    % Incrementation can be 'Exhaustive', 'RandomSubset',
        % 'SuccessiveRandomSubset', or 'VariablePrioritisation'
    % Pattern search can be 'Single' or Indefinite
    evaluations = basepoint.incrementX(LS, stm, evaluations);
    evaluations = basepoint.patternMove(PM, stm, evaluations);
    
    
    mtm.update(basepoint.solution); % Update MTM before intensification
    archive.update(basepoint.solution); % Update archive
    
    % If a new best solution has been found, reset counter & proceed
    if mtm.newbest
        counter = 0;
        continue
    end
    
    % Otherwise, increment counter & proceed to intensification,
    % diversification, or reduction.
    counter = counter + 1;
    switch counter
        case intensify
            %fprintf('Intensify\n');
            basepoint.solution = mtm.intensify();
            evaluations = basepoint.solution.evaluateF(evaluations);
        case diversify
            %fprintf('Diversify\n');
            basepoint.solution = ltm.diversify();
            evaluations = basepoint.solution.evaluateF(evaluations);
        case reduce
            %fprintf('Reduce\n');
            basepoint.solution = mtm.solutions(end);
            basepoint.reduceStepsize(stepreduction);
            counter = 0;
        otherwise
            continue
    end
end
fprintf('Maximum Number of Evaluations Reached\n');

function updatememory(stm, mtm, ltm, solution)
% Update short, medium, and long term memories with new solution
    stm.update(solution);
    mtm.update(solution);
    ltm.update(solution);
end