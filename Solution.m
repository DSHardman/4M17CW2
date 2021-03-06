classdef Solution < handle & matlab.mixin.Copyable
% Single evolution strategy solution, containing location, function
% evaluation, and strategy parameters
    properties
        x % Location
        n % Problem dimensionality
        sigmas % Strategy parameters
        alphas
        value % Function evaluation
    end
    
    methods (Access = public)
        function obj = Solution(x, sigmas, alphas)
        % Constructors
            if nargin == 0
                obj.x = NaN;
                obj.sigmas = NaN;
                obj.alphas = NaN;
                obj.n = NaN;
                obj.value = NaN;
            else
                obj.x = x;
                obj.sigmas = sigmas;
                obj.alphas = alphas;
                obj.n = length(x);
                obj.value = NaN;
            end
        end
        
        function mutateStrat(obj, tau, tau_dash, beta)
        % Mutate strategy parameters
            % Mutate sigmas
            N0 = normrnd(0,1);
            for i = 1:obj.n
                Ni = normrnd(0,1);
                obj.sigmas(i) = obj.sigmas(i)*(exp(tau_dash*N0+tau*Ni));
            end
            % Mutate alphas
            for i = 1:obj.n-1
                for j = i+1:obj.n
                    Nij = normrnd(0,1);
                    obj.alphas(i,j) = obj.alphas(i,j) + beta*Nij;
                end
            end
        end
        
        function mutateX(obj)
        % Mutate control variables
            z = mvnrnd(zeros(obj.n,1),diag(obj.sigmas.^2));
            z = obj.rotateall(z.');
            obj.x = obj.x + z;
        end
        
        function evaluationsout = evaluateF(obj, evaluationsin)
        % Evaluate and update the value property
            evaluationsout = evaluationsin + 1;
            % Return NaN if constraints are violated
            for i = 1:obj.n
                if abs(obj.x(i)) > 500
                    obj.value = NaN;
                    return
                end 
            end
            
            % Rana's Function
            sum = 0;
            for i = 1:obj.n-1
               sum = sum+...
                   obj.x(i)*cos(sqrt(abs(obj.x(i+1)+obj.x(i)+1)))*...
                            sin(sqrt(abs(obj.x(i+1)-obj.x(i)+1)))+...
                   (1+obj.x(i+1))*cos(sqrt(abs(obj.x(i+1)-obj.x(i)+1)))*...
                                  sin(sqrt(abs(obj.x(i+1)+obj.x(i)+1)));
            end
            obj.value = sum;
        end
    end
    
    methods (Access = private)    
        function vecout = rotateall(obj, z)
        % Rotate the multivariate Gaussian used to sample the
        % control space mutations
            vecout = z;
            % Perform the rotations in turn
            for i = 1:length(z)-1
                for j = i+1:length(z)
                    R = eye(length(z));
                    R(i,i) = cos(obj.alphas(i,j));
                    R(i,j) = sin(obj.alphas(i,j));
                    R(j,i) = -sin(obj.alphas(i,j));
                    R(j,j) = cos(obj.alphas(i,j));
                    
                    vecout = R*vecout;
                end
            end
        end
    end
end

