classdef STM < handle
% Tabu search short term memory: stores N last locations visited
    properties
        solutions
        N % Number of solutions stored
    end
    
    methods
        function obj = STM(N)
        % Constructor
            obj.solutions = Solution();
            obj.solutions(N,1) = Solution();
            obj.N = N;
        end
        
        function update(obj, solution)
        % Update short term memory: first in, first out
            for i = obj.N:-1:2
                obj.solutions(i) = copy(obj.solutions(i-1));
            end
            obj.solutions(1) = copy(solution);
        end
        
        function boolout = tabu(obj, solution)
        % Check whether a location is stored in STM
            boolout = 0;
            for i = 1:obj.N
                if isequal(obj.solutions(i).x, solution.x)
                    boolout = 1;
                end
            end
        end
    end
end

