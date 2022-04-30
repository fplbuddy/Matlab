fpath = '/Users/philipwinchester/Dropbox/Matlab/WNL/Functions';
addpath(fpath)
datapath = '/Volumes/Samsung_T5/OldData/WNLData.mat';
load(datapath)
load('/Volumes/Samsung_T5/OldData/NewSteadyState.mat');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions')
%% play
for i=1:length(Fs)
    if real(Fs(i)) == 0
        Fs(i) = imag(Fs(i));
    end
end



%%
N = 32;
n = [-(N/2):2:(N/2-1) -(N/2-1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
positionMatrix = MakePositionMatrix(n,m);
As = 0:0.01:7;
G_list = [2];
%

%%%%
%CS = 0;
% type = ['N_' num2str(N) 'x' num2str(N)];
% M = GetFullMZeronss(Data,GS,"Pr_0_0001",1);
% [~,RaA] = GetNextRaA2nss(M, "Simple",3);
% RaAS = RaAtoRaAS(RaA);
% PsiE = Data.(GS).(type).(PrS).(RaAS).PsiE; % this is the PsiE we have
% % Now we want to pick out the sign of the odd modes
% [~,~,n2,m2,~] = GetRemKeepnss_nxny(Nx,Ny);
% Rem = [];
% for k=1:length(n2)
%     ninst = n2(k); minst = m2(k);
%     if not(rem(ninst+minst,2)) % even modes
%         Rem = [Rem k];
%     end
% end
% n2(Rem) = []; m2(Rem) = []; PsiE(Rem) = []; % removing even modes
% signvector = sign(PsiE);
%%%%%
for j=1:length(G_list)
    G = G_list(j);
    GS = GtoGS(G);
    %ZeroOneFact = zeros(1,length(As));
    Fs = [];
    sigmas = [];
    %loc = find(n == 0); loc = loc(1);
    for i = 1:length(As) % this evaluates F(A) and sigmas
        i
        M = MakeMatrixEigProb(N,G, As(i),0);
        [V, sigma] = eig(M);
        sigma = diag(sigma);
        [~,I] = max(real(sigma));
        V = V(:,I);
        sigmas = [sigmas sigma(I)];
        F = imag(GetF(V,n,m,positionMatrix,N,G));
        Fs = [Fs F];
    end
    % add reverse
    %As = [-As(end:-1:2) As];
    %Fs = [-Fs(end:-1:2) Fs];
    %sigmas = [sigmas(end:-1:2) sigmas];
    %ZeroOneFact = [ZeroOneFact(end:-1:2) ZeroOneFact];
    
    % do the scalings
    Ktwo = (2*pi/G)^2 + pi^2;
    a = (1/pi)*(4*G^3/(Ktwo^2*(4+G^2)^2))^(1/3);
    As = As/a;
    % Save
    if isfield(WNLData.(GS),"As")
        As = [WNLData.(GS).As As];
        Fs = [WNLData.(GS).Fs Fs];
        sigmas = [WNLData.(GS).sigmas sigmas];
        % cleaning
        [As,I] = unique(As,'stable');
        Fs = Fs(I);
        sigmas = sigmas(I);
        % sort
        [As,I] = sort(As);
        Fs = Fs(I);
        sigmas = sigmas(I);
    end
%     WNLData.(GS).As = As;
%     WNLData.(GS).Fs = Fs;
%     WNLData.(GS).sigmas = sigmas;
end
%save(datapath, "WNLData")
%%
G = 2;
GS = GtoGS(G);
Ktwo = (2*pi/G)^2 + pi^2;
a = (1/pi)*(4*G^3/(Ktwo^2*(4+G^2)^2))^(1/3);
Astar =  WNLData.(GS).calcs.Astar;
b = a*(4+G^2)^2*pi^3/(2*G^3);
Ra_list = [836];
RaC = pi^4*(4+G^2)^3/(4*G^4);
eps = 2e-2;
%r_list = [2e4];
r_list = (Ra_list - RaC)*2*pi*a/(G*eps^2);
As = WNLData.(GS).As;
Fs = WNLData.(GS).Fs*b^2;
sigmas = WNLData.(GS).sigmas*b;
tmax = 0.04;
CFL = eps^2/4;
reset = 1;
for i=1:length(r_list)
    r = r_list(i);
    rS = rtorS(r);
    epsS = epstoepsS(eps);
    %if not(isfield(WNLData.(GS).(epsS),rS)) || reset % stat from scratch
    %theta0 = log(sqrt(r));
    theta0 = log(Astar*1.01);
    phi0 = 0;
    solv = Solver_v3([theta0 phi0],tmax,As, sigmas,eps,r,Fs,CFL);
    %WNLData.(GS).(epsS).(rS).r = r;
    %WNLData.(GS).(epsS).(rS).eps = eps;
    WNLData.(GS).(epsS).(rS).theta = solv.y(1,:);
    WNLData.(GS).(epsS).(rS).phi = solv.y(2,:);
    WNLData.(GS).(epsS).(rS).t = solv.x;
    %[A,phi] = Solver_cheb(A0,phi0,tmax,r,As,sigmas,imag(Fs),eps);
    %     else
    %         theta = WNLData.(GS).(epsS).(rS).theta;
    %         phi = WNLData.(GS).(epsS).(rS).phi;
    %         t = WNLData.(GS).(epsS).(rS).t;
    %         rem  = find(isnan(theta));
    %         theta(rem) = [];
    %         phi(rem) = [];
    %         t(rem) = [];
    %         tend = t(end);
    %         theta0 = theta(end);
    %         phi0 = phi(end);
    %         solv = Solver_v3([theta0 phi0],tmax,As, sigmas,eps,r,Fs,CFL);
    %         thetaadd = solv.y(1,:); thetaadd = thetaadd(2:end);
    %         phisadd = solv.y(2,:); phisadd = phisadd(2:end);
    %         tadd = solv.x + tend; tadd = tadd(2:end);
    %         WNLData.(GS).(epsS).(rS).theta = [theta thetaadd];
    %         WNLData.(GS).(epsS).(rS).phi = [phi phisadd];
    %         WNLData.(GS).(epsS).(rS).t = [t tadd];
    %     end
    
    save(datapath, "WNLData")
end

%% some plots
figure('Renderer', 'painters', 'Position', [5 5 700 300])
G = 2;
GS = GtoGS(G);
r = 7e3;
rS = rtorS(r);
plot(WNLData.(GS).eps_0_01.(rS).t, exp(WNLData.(GS).eps_0_01.(rS).theta)), hold on
plot(WNLData.(GS).eps_0_01.(rS).t, exp(WNLData.(GS).eps_0_01.(rS).phi))
title(['$\Gamma = ' num2str(G) ', r =' num2str(r,'%.2e') '$'],'FontSize',20)
ax = gca;
ax.XAxis.FontSize = 16;
ax.YAxis.FontSize = 16;
xlabel('$t_E$', 'FontSize',20)
ylabel('$B$', 'FontSize',20)

%%
x = Solver_test(1e-5,[0 10], -10);
semilogy(x.x,x.y)

%% plot sigma and F
FS = 20;
TE = 'latex';
set(groot,'defaultTextInterpreter',TE);
set(groot, 'DefaultAxesTickLabelInterpreter', TE)
set(groot, 'DefaultLegendInterpreter', TE)
As = WNLData.As;
Fs = WNLData.Fs;
sigmas = WNLData.sigmas;

figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(As, sigmas);
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
xlim([-30 30])
xlabel('$A$', 'FontSize', FS)
ylabel('$\sigma(A)$', 'FontSize', FS)

figure('Renderer', 'painters', 'Position', [5 5 540 200])
plot(As, imag(Fs));
xlim([-30 30])
ax = gca;
ax.XAxis.FontSize = FS;
ax.YAxis.FontSize = FS;
xlabel('$A$', 'FontSize', FS)
ylabel('$F(A)$', 'FontSize', FS)

%% Plot the other time series
figsave = '/Users/philipwinchester/Desktop/Figs/';
rS_list = string(fields(WNLData.Bsmall_1e250.eps_0_001));
%rS_list = ["r_1e4"];
for i=1:length(rS_list)
    figure('Renderer', 'painters', 'Position', [5 5 540 400])
    rS = rS_list(i);
    A = WNLData.Bsmall_1e250.eps_0_001.(rS).A;
    B = WNLData.Bsmall_1e250.eps_0_001.(rS).B/1e250;
    t = WNLData.Bsmall_1e250.eps_0_001.(rS).t;
    r = WNLData.Bsmall_1e250.eps_0_001.(rS).r;
    subplot(2,1,1)
    semilogy(t,abs(A))
    ylabel('$A$', 'FontSize', FS)
    ax = gca;
    ax.XAxis.FontSize = FS;
    ax.YAxis.FontSize = FS;
    xlim([0 max(t)])
    set(gca,'xtick',[])
    
    subplot(2,1,2)
    semilogy(t,abs(B))
    ylabel('$B$', 'FontSize', FS)
    ax = gca;
    ax.XAxis.FontSize = FS;
    ax.YAxis.FontSize = FS;
    xlabel('$t$', 'FontSize', FS)
    sgtitle(['$r = ' num2str(r,'%.2e') ', \epsilon = 1e-3, B_0 = 1e250'  '$'], 'FontSize',FS)
    xlim([0 max(t)])
    saveas(gcf,[figsave num2str(r) 'log250.eps'], 'epsc')
end
%% derivs and stuff
Fsdash = diff(imag(Fs))/mean(diff(As));
sigmadash = diff(sigmas)/mean(diff(As));
figure()
plot(As,imag(Fs),'-o'); hold on
plot(As(1:length(Fsdash)), Fsdash,'-o')
plot(As,sigmas, '-o')
plot(As(1:length(Fsdash)),sigmadash, '-o')

F = 3.28;
Ax = 10.4;
Fdash = -0.206;
sdash = 0.338;
r = (3*Ax^2-Ax^3*Fdash/F)/(1-Fdash*Ax/F); % mine
r = Ax^2 + 2*Ax^2*F/(F-Ax*Fdash); % peter
Bx = sqrt((r*Ax-Ax^3)/F);

p = [1 -(r-3*Ax^2-Bx^2*Fdash) 2*Bx^2*F*sdash];

hej = roots(p)




