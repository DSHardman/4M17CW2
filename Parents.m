classdef Parents < handle
% Evolution strategy parents class, describing a single population
    properties
        solutions
        mu % Number of solutions stored
    end
    
    methods (Access = public)
        function obj = Parents(solutionvec)
        % Constructors
            if nargin == 0
                obj.solutions = NaN;
                obj.mu = NaN;
            else
                obj.solutions = solutionvec;
                obj.mu = length(solutionvec);
            end
        end
        
        function evaluationsout = evaluateAll(obj, evaluationsin)
        % Associate all solutions with an objective function value
            for i = 1:obj.mu
                evaluationsin = obj.solutions(i).evaluateF(evaluationsin);
            end
            evaluationsout = evaluationsin;
        end
        
        function mutateAll(obj, tau, tau_dash, beta)
        % Mutate all strategy parameters and control variables
            for i = 1:obj.mu
                obj.solutions(i).mutateStrat(tau, tau_dash, beta);
                obj.solutions(i).mutateX();
            end
        end
        
        function offspringoutput = recombine(obj, lambda, xmethod, stratmethod)
        % Recombine to create Offspring object of size lambda.
        % 4 types are possible in both control variable & strategy
        % parameter recombination
            solutionarray(lambda,1) = Solution; % array of Solution objects
            for i = 1:lambda
                % Select two parents at random
                parents2 = randsample(obj.solutions, 2, 'false');
                % Defer to correct private functions:
                switch xmethod
                    case 'Discrete'
                        [x, ~] = obj.discrete('x', parents2);
                    case 'GlobalDiscrete'
                        [x, ~] = obj.globalDiscrete('x');
                    case 'Intermediate'
                        [x, ~] = intermediate('x', parents2);
                    case 'GlobalIntermediate'
                        [x, ~] = obj.globalIntermediate('x');
                    otherwise
                        error('Invalid xmethod\n');
                end
                switch stratmethod
                    case 'Discrete'
                        [sigmas, alphas] = obj.discrete('s', parents2);
                    case 'GlobalDiscrete'
                        [sigmas, alphas] = obj.globalDiscrete('s');
                    case 'Intermediate'
                        [sigmas, alphas] = obj.intermediate('s', parents2);
                    case 'GlobalIntermediate'
                        [sigmas, alphas] = obj.globalIntermediate('s');
                    otherwise
                        error('Invalid stratmethod\n');
                end
                
                sol = Solution(x, sigmas, alphas);
                solutionarray(i) = sol;
            end
            
            % Create output
            offspringoutput = Offspring(solutionarray);
        end
        
        function best = returnbest(obj)
            best = obj.solutions(1).value;
            for i = 2:obj.mu
                if obj.solutions(i).value < best
                    best = obj.solutions(i).value;
                end
            end
        end
    end
    
    %% Private recombination methods
    methods (Access = private)
        function [output1, output2] = discrete(obj, property, parents2)
        % Single discrete recombination of population variables    
            n = parents2(1).n;
            if property == 'x' % for control variables
                output1 = zeros(n,1); output2 = 0;
                for i = 1:n
                    output1(i) = randsample([parents2(1).x(i)...
                                            parents2(2).x(i)], 1);
                end
            elseif property == 's' % for strategy parameters
                output1 = zeros(n,1);
                for i = 1:n
                    output1(i) = randsample([parents2(1).sigmas(i) ...
                                    parents2(2).sigmas(i)], 1);
                end
                output2 = zeros(n);
                for i = 1:n-1
                    for j = i:n
                        output2(i,j) = randsample([parents2(1).alphas(i,j)...
                                            parents2(2).alphas(i,j)], 1);
                    end
                end
            else
                error('Recombination property invalid\n');
            end
        end
        
        function [output1, output2] = globalDiscrete(obj, property)
        % Single global discrete recombination of population variables
            n = obj.solutions(1).n;
            if property == 'x' % for control variables
                output1 = zeros(n,1); output2 = 0;
                for i = 1:n
                    options = zeros(obj.mu, 1);
                    for k = 1:obj.mu
                        options(k) = obj.solutions(k).x(i);
                    end
                    output1(i) = randsample(options, 1);
                end
            elseif property == 's' % for strategy parameters
                output1 = zeros(n,1);
                for i = 1:n
                    options = zeros(obj.mu, 1);
                    for k = 1:obj.mu
                        options(k) = obj.solutions(k).sigmas(i);
                    end
                    output1(i) = randsample(options, 1);
                end
                output2 = zeros(n);
                for i = 1:n-1
                    for j = i:n
                        options = zeros(obj.mu, 1);
                        for k = 1:obj.mu
                            options(k) = obj.solutions(k).alphas(i,j);
                        end
                        output2(i,j) = randsample(options, 1);
                    end
                end
            else
                error('Recombination property invalid\n');
            end
        end
        
        function [output1, output2] = intermediate(obj, property, parents2)
            % Single intermediate recombination of population variables
            n = parents2(1).n;
            omega = 0.5;
            
            if property == 'x' % for control variables
                output1 = zeros(n,1); output2 = 0;
                for i = 1:n
                    output1(i) = omega*parents2(1).x(i)+...
                                (1-omega)*parents2(2).x(i);
                end
            elseif property == 's' % for strategy parameters
                output1 = zeros(n,1);
                for i = 1:n
                    output1(i) = omega*parents2(1).sigmas(i)+...
                                 (1-omega)*parents2(2).sigmas(i);
                end
                output2 = zeros(n);
                for i = 1:n-1
                    for j = i:n
                        output2(i,j) = omega*parents2(1).alphas(i,j)+...
                                       (1-omega)*parents2(2).alphas(i,j);
                    end
                end
            else
                error('Recombination property invalid\n');
            end
        end
        
        function [output1, output2] = globalIntermediate(obj, property)
            % Single global intermediate recombination of
            % population variables
            n = obj.solutions(1).n;
            if property == 'x' % for control variables
                output1 = zeros(n,1); output2 = 0;
                for i = 1:n
                    options = zeros(obj.mu, 1);
                    for k = 1:obj.mu
                        options(k) = obj.solutions(k).x(i);
                    end
                    output1(i) = mean(options);
                end
            elseif property == 's' % for strategy parameters
                output1 = zeros(n,1);
                for i = 1:n
                    options = zeros(obj.mu, 1);
                    for k = 1:obj.mu
                        options(k) = obj.solutions(k).sigmas(i);
                    end
                    output1(i) = mean(options);
                end
                output2 = zeros(n);
                for i = 1:n-1
                    for j = i:n
                        options = zeros(obj.mu, 1);
                        for k = 1:obj.mu
                            options(k) = obj.solutions(k).alphas(i,j);
                        end
                        output2(i,j) = mean(options);
                    end
                end
            else
                error('Recombination property invalid\n');
            end
        end
    end
end

