classdef Solution < handle & matlab.mixin.Copyable
% Single tabu search solution, containing location and function evaluation
    properties
        x % Location
        value % Function evaluation
    end
    
    methods
        function obj = Solution(x, f)
        % Constructors
            if nargin == 2
                obj.x = x;
                obj.value = f;
            elseif nargin == 1
                obj.x = x;
                obj.value = NaN;
            else
                obj.x = NaN;
                obj.value = NaN;
            end
        end
        
        function evaluationsout = evaluateF(obj, evaluationsin)
        % Evaluate and update the value property
            evaluationsout = evaluationsin + 1;
            % Return NaN if constraints are violated
            for i = 1:length(obj.x)
                if abs(obj.x(i)) > 500
                    obj.value = NaN;
                    return
                end 
            end
            
            % Rana's Function
            sum = 0;
            for i = 1:length(obj.x)-1
               sum = sum+...
                   obj.x(i)*cos(sqrt(abs(obj.x(i+1)+obj.x(i)+1)))*...
                            sin(sqrt(abs(obj.x(i+1)-obj.x(i)+1)))+...
                   (1+obj.x(i+1))*cos(sqrt(abs(obj.x(i+1)-obj.x(i)+1)))*...
                                  sin(sqrt(abs(obj.x(i+1)+obj.x(i)+1)));
            end
            
            obj.value = sum;
        end
        
        function boolout = violation(obj)
        % Check for constraint violations
            boolout = 0;
            for i = 1:length(obj.x)
                if abs(obj.x(i)) > 500
                    boolout = 1;
                    return
                end
            end
        end
    end
end

