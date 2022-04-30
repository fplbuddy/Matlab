fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
fpath2 = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions/';
fpath3 = '/Users/philipwinchester/Dropbox/Matlab/Normal/Functions/';
fpath4 = '/Users/philipwinchester/Dropbox/Matlab/Low_Dim/Functions';
addpath(fpath)
addpath(fpath2)
addpath(fpath3)
addpath(fpath4)
x0 = [0.3940,-0.0604, 0.0118];
Ra_list = 8*pi^4 + logspace(-4, 3, 100);
results = [];
Pr = 1;
G = 2;
for i=1:length(Ra_list)
    Ra = Ra_list(i);
    x = fsolve(@(x) steady(x, Ra, Pr, G),x0);
    x0 = x;
    results = [results x(1)];
end

%% Plot pitchfork
spath = '/Users/philipwinchester/Dropbox/Docs/SummaryOfResults/Update_27';
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
FS = 18;
fig = figure('Renderer', 'painters', 'Position', [5 5 700 400]);
plot(Ra_list, results, 'b'); hold on
plot(Ra_list, -results, 'b');
plot([600 max(Ra_list)], [0 0], 'b');
ax = gca;
ax.YAxis.FontSize = FS;
ax.XAxis.FontSize = FS;
xlabel('Ra', 'FontSize', FS)
ylabel('$\widehat\psi_{0,1}$', 'FontSize', FS)
%saveas(fig,[spath '/pitch'], 'epsc')
hold off

%% calculate gradient
results(1:7) = [];
Ra_list(1:7) = [];
figure
loglog(Ra_list-8*pi^4,results, '-o')
[alpha, A, ~, ~, ~] = FitsPowerLaw(Ra_list-8*pi^4,results);
stop

%% Check stability of steady states
x0 = [2.26561054185007,-0.157925530345492,-0.178898873189005]; % This is the steady state at Pr = 30, Ra = 1.78e3
G = 2;
Pr = 8;
delta = 1e-5;
Ra_list = logspace(6, 7, 5);
tupper = 10^2; % Need to vary this
for i=1:length(Ra_list)
    Ra = Ra_list(i);
    kappa = sqrt(pi^3/(Ra*Pr));
    tmax = tupper*kappa/pi^2;
    x0 = fsolve(@(x) steady(x, Ra, Pr, G),x0);
    y = SolveODE(G,Ra,Pr,[0 x0(1) delta delta delta x0(2) 0 delta delta x0(3)],[0 tmax]);
    RaS = RatoRaS(Ra);
    results.(RaS).t = y.x;
    results.(RaS).y = y.y;
end


