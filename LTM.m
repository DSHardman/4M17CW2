classdef LTM < handle
% Tabu search long term memory: stores visit frequency in a grid over
% the control space
    properties
        visits % Number of visits to each grid square
        n % Dimensionality of search space
        divisions % Number of grid divisions per variable
    end
    
    methods
        function obj = LTM(n, divisions)
        % Constructor
            obj.visits = zeros(divisions^n, 1);
            obj.n = n;
            obj.divisions = divisions;
        end
        
        function update(obj, solution)
        % Update long term memory
            % NaN scores are not updated
            if isnan(solution.value)
                return
            end
            % Convert grid location into an n-digit number in base B, 
            % where B is the number of divisions per variable
            baseStr = '';
            for i = 1:obj.n
                baseStr = strcat(baseStr,string(...
                    floor(obj.divisions*(solution.x(i)+500)/1000)));
            end
            % Convert this to decimal, and update 'visits' array at this
            % index
            D = base2dec(baseStr, obj.divisions);
            obj.visits(D+1) = obj.visits(D+1) + 1;
        end
        
        function solutionout = diversify(obj)
        % Diversification: Return random solution in least visited square
            % If multiple squares have the same minimum number of visits,
            % randomly sample amongst them
            indicies = find(obj.visits==min(obj.visits));
            index = indicies(randsample(length(indicies),1));
            segment = dec2base(index-1, obj.divisions, obj.n);
            % Sample a location from chosen square
            xout = zeros(obj.n, 1);
            for i = 1:obj.n
                minimum = (str2double(segment(i))*1000)/obj.divisions - 500;
                maximum = ((str2double(segment(i))+1)*1000)/obj.divisions - 500;
                xout(i) = minimum + (maximum-minimum)*rand();
            end
            % Create output
            solutionout = Solution(xout);
        end
    end
end

