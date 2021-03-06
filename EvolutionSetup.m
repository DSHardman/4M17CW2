% Problem dimensionality
n = 5;

% Population sizes
mu = 40;%10; % Number of parents
lambda = 40;%100; % Number of offspring

% Learning parameters
tau = 0.5/(sqrt(2*sqrt(n)));
tau_dash = 0.5/(sqrt(2*n));
beta = pi/180;

% Selection type
sel = 'Plus';

% Stopping criteria
maxevaluations = 10000;
epsilon_c = 0.001;

%Archive parameters
L = 10;
Dsim = 5; % Dissimilarity thresholds
Dmin = 15*Dsim;


%Choose starting point & instantiate objects
clear solutionvec
solutionvec(mu, 1) = Solution();
for i = 1:mu
    x = 1000*rand(n, 1) - 500;
    sigmas = 10*ones(n, 1);
    alphas = zeros(n);
    for p = 1:n-1
        for q = p+1:n
            alphas(p,q) = 1*rand(1, 1) - 0.5;
        end
    end
    
    solutionvec(i) = Solution(x, sigmas, alphas);
end
parents = Parents(solutionvec);
archive = Archive(L, Dmin, Dsim);

% For 2D case, visualise live on a contour plot
if n == 2
    zfun = @(x,y) x*cos(sqrt(abs(y+x+1)))*sin(sqrt(abs(y-x+1)))+...
        (1+y)*cos(sqrt(abs(y-x+1)))*sin(sqrt(abs(y+x+1)));
    f = figure();
    subplot(2,2,4);
    fcontour(zfun, [-500 500 -500 500]); hold on; ax = gca;
    xlim([-500 500]); ylim([-500 500]);
    xlabel('x_1');
    ylabel('x_2');
end