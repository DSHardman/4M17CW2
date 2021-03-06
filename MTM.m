classdef MTM < handle
% Tabu search medium term memory: stores M best solutions found so far
    properties
        solutions
        M % Number of solutions stored
        newbest % Boolean: did the last update find a new best?
    end
    
    methods
        function obj = MTM(M)
        % Constructor
            obj.solutions = Solution();
            obj.solutions(M,1) = Solution();
            obj.M = M;
            obj.newbest = 0;
        end
        
        function update(obj, solution)
        % Update medium term memory
            % NaN scores are not updated
            if isnan(solution.value)
                return
            end
            
            % Update Boolean flag
            if solution.value < obj.solutions(end).value
                obj.newbest = 1;
            else
                obj.newbest = 0;
            end
            
            % Update if score is better than the memory's worst score, and
            % if location is not identical to existing entry
            % Strange syntax handles NaN values:
            if ~(solution.value > obj.solutions(1).value)
                for i = 1:obj.M
                    if isequal(solution.x, obj.solutions(i).x)
                        return
                    end
                end
                obj.solutions(1) = copy(solution);
            else
                return
            end
            
            % Sort solutions in memory by score
            [~, ind] = sort([obj.solutions.value], 'descend');
            sortedsolutions(obj.M,1) = Solution();
            for i = 1:obj.M
                sortedsolutions(i) = copy(obj.solutions(ind(i)));
            end
            obj.solutions = sortedsolutions;
        end
            
        function solutionout = intensify(obj)
        % Intensification: returns average of best solutions so far
            xout = zeros(size(obj.solutions(1).x));
            for i = 1:length(obj.solutions(1).x)
                options = zeros(obj.M,1);
                for j = 1:obj.M
                    options(j) = obj.solutions(j).x(i);
                end
                xout(i) = mean(options);
            end
            solutionout = Solution(xout);
        end
        
    end
end

