classdef Offspring < handle
% Evolution strategy offspring class, containing a vector (length lambda)
% of solutions.
    properties
        solutions
        lambda % Number of offspring 
    end
    
    methods
        function obj = Offspring(solutionvec)
        % Constructors
            if nargin == 0
                obj.solutions = NaN;
                obj.lambda = NaN;
            else
                obj.solutions = solutionvec;
                obj.lambda = length(solutionvec);
            end
        end
        
        function evaluationsout = evaluateAll(obj, evaluationsin)
        % Associate all solutions with an objective function value
            for i = 1:obj.lambda
                evaluationsin = obj.solutions(i).evaluateF(evaluationsin);
            end
            evaluationsout = evaluationsin;
        end
        
        function parentsoutput = select(obj, mu, parents, type)
        % Select to create Parents object of size mu.
            switch type
                case 'Comma' % (mu, lambda) selection
                    % Sort offspring by value and select mu lowest
                    [~, ind] = sort([obj.solutions.value], 'ascend');
                    solutionarray = obj.solutions(ind(1:mu));
                case 'Plus' % (mu + lambda) selection
                    % Create array off offspring and parent solutions
                    solutionarray(parents.mu+obj.lambda,1) = Solution;
                    for i = 1:obj.lambda
                        solutionarray(i) = obj.solutions(i);
                    end
                    for i = 1:parents.mu
                        solutionarray(obj.lambda+i) = parents.solutions(i);
                    end

                    % Sort array by value and select mu lowest
                    [~, ind] = sort([solutionarray.value], 'ascend');
                    solutionarray = solutionarray(ind(1:mu));
                otherwise
                    error('Unexpected selection type');
            end
            
            % Prevent solutions which violate the constraints from
            % becoming parents. Necessary if there are fewer than mu
            % feasible offspring. 
            arraycopy = [];
            for i = 1:length(solutionarray)
                if ~isnan(solutionarray(i).value)
                    arraycopy = [arraycopy; solutionarray(i)];
                end
            end
            
            % Create Output
            if length(arraycopy) >= 2
                parentsoutput = Parents(arraycopy);
            else % If there are fewer than 2 offspring within the valid
                % parameter range, the same parents are tried again.
                parentsoutput = parents;
            end
        end
        
        function boolout = halt(obj, epsilon_c)
        % Check if stopping criterion achieved
            boolout = 0;
            % Sort offspring by value and find absolute range
            [~, ind] = sort([obj.solutions.value], 'ascend');
            diff = abs(obj.solutions(ind(end)).value-...
                obj.solutions(ind(1)).value);
            if diff <= epsilon_c
                boolout = 1;
            end
        end
        
    end
end

