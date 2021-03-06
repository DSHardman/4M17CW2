classdef Basepoint < handle
% Tabu Search basepoint, containing current solution and information about
% the search method
    properties (Access = public)
        solution
        n % Dimension of search space 
        pattern % Associated with last x increment
        stepsize % Current size of x increments
    end
    properties (Access = private)
        n_subsets % For (successive) random subset local searches
        sensitivities % Array of x sensitivities in variable prioritisation
        plimit % Iterations before sensitivities updated
        pcounter % Iterations since sensitivities updated
    end
    
    methods
        function obj = Basepoint(x, stepsize)
        % Constructor
            obj.solution = Solution(x);
            obj.solution.evaluateF(0);
            obj.n = length(x);
            obj.stepsize = stepsize;
            obj.pattern = NaN;
            obj.n_subsets = NaN;
            obj.sensitivities = NaN;
            obj.plimit = NaN;
            obj.pcounter = 0;
        end
        
        function evaluationsout = incrementX(obj, type, stm, evaluationsin)
        % Local search: 4 types are possible
            best = Solution();
            switch type
                case 'Exhaustive' % Test all variable incrementations 
                    for i = 1:2*obj.n
                        delta = zeros(obj.n,1);
                        delta(ceil(i/2)) = 2*mod(i,2) - 1;
                        sol = Solution(obj.solution.x+obj.stepsize*delta);
                        % Tabu moves & constraint violations not accepted
                        if stm.tabu(sol) || sol.violation()
                            continue
                        end
                        evaluationsin = sol.evaluateF(evaluationsin);
                        % Strange syntax handles NaN values:
                        if ~(sol.value > best.value)
                            best = sol; % Update best solution
                            obj.pattern = delta; % Save best move
                        end
                    end
                    
                case 'RandomSubset' % Test n_subsets random moves each time
                    randommoves = randsample(2*obj.n, obj.n_subsets);
                    for i = 1:obj.n_subsets
                        delta = zeros(obj.n,1);
                        delta(ceil(randommoves(i)/2)) = ...
                            2*mod(randommoves(i),2) - 1;
                        sol = Solution(obj.solution.x+obj.stepsize*delta);
                        % Tabu moves & constraint violations not accepted
                        if stm.tabu(sol) || sol.violation()
                            continue
                        end
                        evaluationsin = sol.evaluateF(evaluationsin);
                        % Strange syntax handles NaN values:
                        if ~(sol.value > best.value)
                            best = sol; % Update best solution
                            obj.pattern = delta; % Save best move
                        end
                    end     
                    
                case 'SuccessiveRandomSubsets' % Test n_subsets random 
                % moves until an improvement is found
                    randommoves = randsample(2*obj.n, 2*obj.n);
                    outflag = 0;
                    for k = 1:floor(obj.n/obj.n_subsets)
                        for i = (k-1)*(obj.n_subsets)+1:...
                                min(k*obj.n_subsets, obj.n)
                            delta = zeros(obj.n,1);
                            delta(ceil(randommoves(i)/2)) = ...
                                2*mod(randommoves(i),2) - 1;
                            sol = Solution(...
                                obj.solution.x+obj.stepsize*delta);
                            % Tabu moves & constraint violations not accepted
                            if stm.tabu(sol) || sol.violation()
                                continue
                            end
                            evaluationsin = sol.evaluateF(evaluationsin);
                            % Strange syntax handles NaN values:
                            if ~(sol.value > best.value)
                                best = sol; % Update best solution
                                obj.pattern = delta; % Save best move
                                % Quit if new best found
                                if sol.value < obj.solution.value
                                    outflag = 1;
                                end
                            end
                        end
                        if outflag
                            break
                        end
                    end                   
                    
                case 'VariablePrioritisation'
                % Varies control parameters with the greatest effects
                    % Update sensitivities every plimit iterations
                    if obj.pcounter == 0
                        obj.sensitivities = zeros(obj.n, 1);
                        for i = 1:obj.n
                            deltaup = zeros(obj.n,1);
                            deltadown = zeros(obj.n,1);
                            deltaup(i) = 1; deltadown(i) = -1;
                            solup = Solution(...
                            obj.solution.x+obj.stepsize*deltaup);
                            soldown = Solution(...
                                obj.solution.x+obj.stepsize*deltadown);
                            evaluationsin = solup.evaluateF(evaluationsin);
                            evaluationsin = soldown.evaluateF(evaluationsin);
                            
                            % Sensitivity definition
                            obj.sensitivities(i) = ...
                                abs((solup.value-soldown.value)/...
                                (2*obj.stepsize));
                        end
                    end
                    
                    % Sort sensitivities, and chose n/2 highest
                    [~, ind] = sort([obj.sensitivities], 'descend');
                    for i = 1:2*floor(obj.n/2)
                        delta = zeros(obj.n,1);
                        delta(ind(ceil(i/2))) = 2*mod(i,2) - 1;
                        sol = Solution(obj.solution.x+obj.stepsize*delta);
                        % Tabu moves & constraint violations not accepted
                        if stm.tabu(sol) || sol.violation()
                            continue
                        end
                        evaluationsin = sol.evaluateF(evaluationsin);
                        % Strange syntax handles NaN values:
                        if ~(sol.value > best.value)
                            best = sol; % Update best solution
                            obj.pattern = delta; % Save best move
                        end 
                    end
                    
                    % Update prioritisation counter
                    obj.pcounter = obj.pcounter + 1;
                    obj.pcounter = mod(obj.pcounter,obj.plimit);
                otherwise
                    error ('Invalid Increment Type\n');
            end
            evaluationsout = evaluationsin;
            obj.solution = best;
        end
        
        function evaluationsout = patternMove(obj, type, stm, evaluationsin)
        % Pattern move: 2 types are possible
            switch type
                case 'Single' % Repeat move once if this improves score
                    sol = Solution(...
                        obj.solution.x+obj.stepsize*obj.pattern);
                    evaluationsin = sol.evaluateF(evaluationsin);
                    % Tabu moves & constraint violations not accepted
                    if (sol.value < obj.solution.value) &&...
                            ~stm.tabu(sol) && ~sol.violation()
                        obj.solution = sol;
                    end
                case 'Indefinite' % Repeat move until score doesn't improve
                    while 1
                        sol = Solution(...
                            obj.solution.x+obj.stepsize*obj.pattern);
                        evaluationsin = sol.evaluateF(evaluationsin);
                        % Tabu moves & constraint violations not accepted
                        if (sol.value < obj.solution.value) &&...
                                ~stm.tabu(sol) && ~sol.violation()
                            obj.solution = sol;
                        else
                            break
                        end
                    end
                otherwise
                    error('Invalid Pattern Move Type\n');
            end
            evaluationsout = evaluationsin;
        end
        
        function reduceStepsize(obj, factor)
        % Reduce step size of local searches
            obj.stepsize = factor*obj.stepsize; 
        end
        
        function boolout = quitSearch(obj, epsilon)
        % Test to see whether stopping criteria is achieved
            boolout =  (obj.stepsize < epsilon);
        end
        
        function setNsubsets(obj, n_subsets)
        % Set (successive) random subset controls
            obj.n_subsets = n_subsets;
        end
        
        function setPrioritisation(obj, plimit)
        % Set variable prioritisation controls
            obj.plimit = plimit;
        end
        
    end
end

