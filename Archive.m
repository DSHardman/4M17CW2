classdef Archive < handle
% Evolution strategy archive, containing best L AND best L dissimilar solutions
    properties
        L
        s_solutions % Best L solutions
        d_solutions % Best L dissimilar solutions
        Dmin % Dissimilarity thresholds
        Dsim
    end
    
    methods (Access = public)
        function obj = Archive(L, Dmin, Dsim)
            % Constructor
            obj.L = L;
            obj.Dmin = Dmin;
            obj.Dsim = Dsim;
            obj.s_solutions = Solution();
            obj.s_solutions(L,1) = Solution();
            obj.d_solutions = Solution();
            obj.d_solutions(L,1) = Solution();
        end
        
        function update(obj, offspring)
        % Update both archive arrays
            for i = 1:offspring.lambda
                obj.update_s(offspring.solutions(i));
                obj.update_d(offspring.solutions(i));
            end
        end
    end
    methods (Access = private)
        function Darray = dissimilarities(obj, xtest)
        % Calculate dissimilarites of xtest against all solutions in
        % d_solutions array
            Darray = zeros(obj.L, 1);
            for i = 1:obj.L
                Darray(i) = norm(obj.d_solutions(i).x - xtest);
            end
        end
 
        function update_s(obj, solution)
        % Update best L solutions
            % NaN scores are not updated
            if isnan(solution.value)
                return
            end
            
            % Strange syntax handles NaN values:
            if ~(solution.value > obj.s_solutions(1).value)
                obj.s_solutions(1) = copy(solution);
            else
                return
            end
            
            % Sort solutions in archive by score
            [~, ind] = sort([obj.s_solutions.value], 'descend');
            sortedsolutions(obj.L,1) = Solution();
            for i = 1:obj.L
                sortedsolutions(i) = copy(obj.s_solutions(ind(i)));
            end
            obj.s_solutions = sortedsolutions;  
        end
        
        function update_d(obj, solution)
        % Update best L dissimilar solutions
            % NaN scores are not updated
            if isnan(solution.value)
                return
            end
            % Calculate dissimilarities
            Darray = dissimilarities(obj, solution.x);
            % Find index of closest solution
            [~, closest] = min(Darray);
            
            % Apply dissimilarity archiving rules
            if isnan(obj.d_solutions(end).value)
                obj.d_solutions(1) = copy(solution);
            elseif ~(solution.value > obj.d_solutions(1).value) &&...
                    min(Darray) > obj.Dmin
                obj.d_solutions(1) = copy(solution);
            elseif solution.value < min([obj.d_solutions.value])
                obj.d_solutions(closest) = copy(solution);
            elseif solution.value < obj.d_solutions(closest).value &&...
                    Darray(closest) < obj.Dsim
                obj.d_solutions(closest) = copy(solution);
            else
                return
            end            
            
            % Sort solutions in archive by score
            [~, ind] = sort([obj.d_solutions.value], 'descend');
            sortedsolutions(obj.L,1) = Solution();
            for i = 1:obj.L
            	sortedsolutions(i) = obj.d_solutions(ind(i));
            end
            obj.d_solutions = sortedsolutions;
        end
    end
end

