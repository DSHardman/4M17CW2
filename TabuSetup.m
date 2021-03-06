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
epsilon = 0;%0.001;

% Archive parameters
L = 10;
Dsim = 5; % Dissimilarity thresholds
Dmin = 15*Dsim;

% Instantiate objects
stm = STM(N);
mtm = MTM(M);
ltm = LTM(n, divisions);
archive = Archive(L, Dmin, Dsim);

% Methods
LS = 'Exhaustive'; % Local search
PM = 'Indefinite'; % Pattern move

% Choose starting point
%basepoint = Basepoint(zeros(n,1), stepsize); % zeros
basepoint = Basepoint(1000*rand(n,1)-500, stepsize); % random

%basepoint.setNsubsets(2);
%basepoint.setPrioritisation(5);

% For 2D case, visualise live on a contour plot
if n == 2
    zfun = @(x,y) x*cos(sqrt(abs(y+x+1)))*sin(sqrt(abs(y-x+1)))+...
        (1+y)*cos(sqrt(abs(y-x+1)))*sin(sqrt(abs(y+x+1)));
    f = figure();
    subplot(2,2,4)
    fcontour(zfun, [-500 500 -500 500]); hold on; ax = gca;
    subplot(2,2,3)
    fcontour(zfun, [-500 500 -500 500]); hold on; ax3 = gca;
    subplot(2,2,2)
    fcontour(zfun, [-500 500 -500 500]); hold on; ax2 = gca;
    subplot(2,2,1)
    fcontour(zfun, [-500 500 -500 500]); hold on; ax1 = gca;
end