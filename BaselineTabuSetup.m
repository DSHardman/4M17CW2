% Problem dimensionality
n = 5;

% Control thresholds
intensify = 10;
diversify = 15;
reduce = 25;

% Step size
stepsize = 50; % Initial
stepreduction = 0.9; % Reduction factor

% Memory parameters
N = 5; % Short term
M = 4; % Medium term
divisions = 2; % Long term

% Stopping criteria
maxevaluations = 10000;
epsilon = 0.001;

% Archive parameters
L = 10;
Dsim = 5; % Dissimilarity thresholds
Dmin = 15*Dsim;

% Instantiate objects
stm = STM(N);
mtm = MTM(M);
ltm = LTM(n, divisions);
archive = Archive(L, Dmin, Dsim);

% Choose starting point
basepoint = Basepoint(zeros(n,1), stepsize);

% EXHAUSTIVE & SINGLE METHODS USED