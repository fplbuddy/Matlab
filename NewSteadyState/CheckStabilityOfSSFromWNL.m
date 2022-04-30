%% params
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/NewSteadyState/Functions')
datapath = '/Volumes/Samsung_T5/OldData/WNLData.mat';
load(datapath)
RaA_list = [1.62e-3 1.63e-3];
Pr = 1e-4; PrT = RatoRaT(Pr);
cmap = colormap(winter(length(RaA_list)));
figure('Renderer', 'painters', 'Position', [5 5 540 200])
for k=1:length(RaA_list)
    RaA = RaA_list(k); G = 2; GS = GtoGS(G); N = 32;
    Ra = RaCfunc(G) + RaA;
    %%
    n = [-(N/2):2:(N/2-1) -(N/2-1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
    m = 1:N; m = repelem(m, N/2);
    [~,~,n,m] = GetRemGeneral(n,m,N);
    %% Build steady state
    Ktwo = (2*pi/G)^2 + pi^2;
    a = (1/pi)*(4*G^3/(Ktwo^2*(4+G^2)^2))^(1/3);
    Astar =  WNLData.(GS).calcs.Astar;
    A = Astar*a;
    M = MakeMatrixEigProb(N,G, A,0);
    [V, sigma] = eig(M);
    sigma = diag(sigma);
    [~,I] = max(real(sigma));
    V = V(:,I);
    PsiO1 = V; % this tells us what the odd modes are in PsiE to leading order
    % calculuate B, first in nice coordinates, then transform back
    r = RaA/Pr^2; r = 2*pi*a*r/G % r is in nice coordinates
    b = a*(4+G^2)^2*pi^3/(2*G^3);
    Fs = WNLData.(GS).Fs*b^2;
    B = sqrt((r*Astar-Astar^3)/interp1(WNLData.(GS).As,Fs,Astar));
    B = b*B; % transforming back to original coordinates
    PsiO1 = B*Pr*PsiO1;
    % Now make ThetaO1
    ThetaO1 = zeros(length(PsiO1),1);
    for i=1:length(ThetaO1)
        ThetaO1(i) = PsiO1(i)*1i*(2*pi*n(i)/G)/((2*pi*n(i)/G)^2+(pi*m(i))^2);
    end
    % now build the thing
    [~,~,n2,m2,~] = GetRemKeepnss_nxny(N,N);
    PsiE = zeros(length(n2),1);
    ThetaE = zeros(length(n2),1);
    for i=1:length(n)
        for j=1:length(n2)
            if n(i) == n2(j) && m(i) == m2(j)
                PsiE(j) = PsiO1(i);
                ThetaE(j) = imag(ThetaO1(i));
            end
        end
    end
    % add even modes
    for i=1:length(n2)
        if n2(i) == 1 && m2(i) == 1
            PsiE(i) = -(pi*A/2)*(4+G^2)/G;
            ThetaE(i) = A;
        end
        if n2(i) == 0 && m2(i) == 2
            ThetaE(i) = -Pr*pi*A^2*(4+G^2)/(2*G^2);
        end
    end
    PsiE = PsiE*Pr;
    ThetaE = ThetaE*Pr;
    % I have probably messed up sign, but pretty confident this is fine. So
    % will just change now
    % comparison
    path = '/Volumes/Samsung_T5/OldData/NewSteadyState.mat';
    load(path)
    PsiECheck = Data.G_2.N_32x32.Pr_0_0001.RaA_1_02e_3.PsiE;
    ThetaECheck = Data.G_2.N_32x32.Pr_0_0001.RaA_1_02e_3.ThetaE;
    for i=1:length(n2)
        PsiE(i) = sign(PsiECheck(i))*abs(PsiE(i));
        ThetaE(i) = sign(ThetaECheck(i))*abs(ThetaE(i));
    end
    %% now do stability analysis
    addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions');
    M = MakeMatrix_nxny2(N,N,G, PsiE, ThetaE, Ra, Pr,0);
    sigma = eig(M);
    plot(real(sigma),imag(sigma),'*','MarkerSize',10,'Color',cmap(k,:),'DisplayName',num2str(RaA)),hold on
end
xlim([-1e-10 1e-10])
ylim([-3e-6 3e-6])
lgnd = legend('Location', 'Bestoutside'); title(lgnd,'$\delta$Ra')
title(['Pr $=' PrT ', \Gamma =' num2str(G) '$, WNL SS'])

xlabel('$Real(\sigma)$')
ylabel('$Imag(\sigma)$')


%% Check when becomes unstable according to WNL
r = 1.53e4; % nice coordinates
r = r*G/(2*pi*a);
RaA = r*Pr^2; 
