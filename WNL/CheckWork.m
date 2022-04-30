%
% The first analysis here is all done before the funky scaling
%
clearvars -except Data WNLData PrZeroData
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m

load('/Volumes/Samsung_T5/OldData/NewSteadyState.mat');
load('/Volumes/Samsung_T5/OldData/WNLData.mat');
load('/Volumes/Samsung_T5/OldData/PrZeroData.mat');
addpath('/Users/philipwinchester/Dropbox/Matlab/NewSteadyState/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions')
Pr = 1e-4; %PrS = 'Pr_1e_5';
PrS = PrtoPrS(Pr); 
PrT = RatoRaT(Pr);
G = 2; GS = GtoGS(G);
Ktwo = (2*pi/G)^2 + pi^2;
a = (1/pi)*(4*G^3/(Ktwo^2*(4+G^2)^2))^(1/3);
pitchr = WNLData.(GS).calcs.pitch;
hopfWNL = WNLData.(GS).calcs.hopf;
hopfWNLr = hopfWNL*G/(2*pi*a);
pitchr = pitchr*G/(2*pi*a);
RaAC = pitchr*Pr^2;
N = 32; type = ['N_' num2str(N) 'x' num2str(N)];
Astar = WNLData.(GS).calcs.Astar;
Astarnormal = Astar*a;
FAstar = interp1(WNLData.(GS).As,WNLData.(GS).Fs,Astar);
PsiOneOne = Astarnormal*pi*(4+G^2)/(2*G);
%% Calculating B
RaAS_list = string(fields(Data.(GS).(type).(PrS)));
[~,~,n,m,~] = GetRemKeepnss_nxny(N,N);
evenmodes = [];
for i=1:length(n)
   if not(rem(n(i) + m(i),2))
       evenmodes = [evenmodes i];
   end  
end

% for i=1:length(RaAS_list)
%     RaAS = RaAS_list(i); RaA = RaAStoRaA(RaAS);
%     PsiE = Data.(GS).(type).(PrS).(RaAS).PsiE;
%     ls = Data.(GS).(type).(PrS).(RaAS).lowPrScaling;
%     PsiE = PsiE/(Pr)^(1-ls); % putting it into the right scaling
%     PsiE(evenmodes) = []; % removing even modes
%     B = norm(PsiE)/Pr;
%     B_list(i) = B;
%     RaA_list(i) = RaA;
% end
% %%
% [RaA_list,I] = sort(RaA_list);
% B_list = B_list(I);
% figure()
% %plot(FAstar*B_list.^2,Astarnormal*(2*pi/G)*(RaA_list-RaAC)/Pr^2,'*')
% semilogx(RaA_list-RaAC,FAstar*B_list.^2./(Astarnormal*(2*pi/G)*(RaA_list-RaAC)/Pr^2),'*')
% 
% [alpha, A, ~, ~, Rval] = FitsLinear(FAstar*B_list.^2,Astarnormal*(2*pi/G)*(RaA_list-RaAC)/Pr^2);

%% Do the same thing, but for the actual NRR sovler
%%%%%% bellow looks dodgy. Can i use it to calculate F and see if it is
%%%%%% constant or not??
%%%%% The even thing we are linearisng round changes slightly, therefor
%%%%% also the eigenfunction and F. F changes very quickly with A when G is
%%%%% small.
% [Rem,~,n,m,signvector] = GetRemKeepnss_nxny(N,N);
% hej = [];
% RaAS_list = RaAS_list(I);
% for i=1:length(RaAS_list)
%     RaAS = RaAS_list(i); RaA = RaAStoRaA(RaAS);
%     PsiE = Data.(GS).(type).(PrS).(RaAS).PsiE;
%     ThetaE = Data.(GS).(type).(PrS).(RaAS).ThetaE;
%     %ls = Data.(GS).(type).(PrS).(RaAS).lowPrScaling;
%     PsiE = PsiE/(Pr)^(1-ls); % putting it into the right scaling
%     ThetaE = ThetaE/(Pr)^(1-ls);
%     PsiE(evenmodes) = 0; % setting even modes to 0
%     ThetaE(evenmodes) = 0;
%     RaA_list(i) = RaA;
%     [~,Eval] = EvaluationAndJacnss(PsiE, ThetaE, RaCfunc(G)+RaA, Pr,G,Rem,n,m, signvector,1);
%     oddcont_list(i) = Eval(2)/Pr^2;
%     max(abs(Eval))
%     hej = [hej PsiE];
% end

% for i=2:width(hej)
%     svej(:,i) = hej(:,i)./hej(:,i-1); 
% end

%% plot A, B from full system
RaA_list = []; A_listFS = []; B_listFS = [];
PrSZ = PrtoPrSZero(Pr);
D = GetFullMZero(PrZeroData, GS,PrSZ, "Odd", "N_32");
signs = sign(D(2,:)); I = find(signs+1,1,"first");
RaApitch = D(1,:); RaApitch = RaApitch(I);
D = GetFullMZeronss(Data,GS,PrS,1,"N_32x32");
signs = sign(D(2,:)); I = find(signs+1,1,"first");
RaAhopf = D(1,:); RaAhopf = RaAhopf(I);
%% Do SCRS first
type = ['N_' num2str(N)];
RaAS_list = string(fields(PrZeroData.(GS).(type).(PrSZ)));
for i=1:length(RaAS_list)
    RaAS = RaAS_list(i); RaA = RaAStoRaA(RaAS); 
    if RaA < RaApitch
    RaA_list = [RaA_list RaA];
    PsiE = PrZeroData.(GS).(type).(PrSZ).(RaAS).PsiE/Pr;
    A = abs(PsiE(1))*2*G/(pi*(4+G^2));
     A_listFS = [A_listFS A];
    B_listFS = [B_listFS 0];
    end
end

%% Now do new SS
type = ['N_' num2str(N) 'x' num2str(N)];
RaAS_list = string(fields(Data.(GS).(type).(PrS)));
for i=1:length(RaAS_list)
    RaAS = RaAS_list(i); RaA = RaAStoRaA(RaAS); 
    if RaA < RaAhopf
    RaA_list = [RaA_list RaA];
    ls = Data.(GS).(type).(PrS).(RaAS).lowPrScaling
    PsiE = Data.(GS).(type).(PrS).(RaAS).PsiE;
    %PsiE = PsiE/(Pr)^(1-ls); % putting it into the right scaling
    A = (abs(PsiE(2))*2*G/(pi*(4+G^2)))/Pr;
    A_listFS = [A_listFS A];
    PsiE(evenmodes) = []; % removing even modes
    %B = norm(PsiE)/Pr;
    B = norm(PsiE)/Pr^2; % this this is right
    B_listFS = [B_listFS B];
    end
end

%%
[RaA_list,I] = sort(RaA_list);
B_listFS =  B_listFS(I);
A_listFS =  A_listFS(I);
r_list = RaA_list/Pr^2;

%% now do what we have from model
A_listWNL = []; B_listWNL = [];
rc = (4+G^2)^4*pi^6*Astarnormal^2/(8*G^6);
for i=1:length(RaA_list)
    RaA = RaA_list(i);
    r = r_list(i);   
    if RaA < RaApitch
        A = sqrt(8*r*G^6/(pi^6*(4+G^2)^4));
        A_listWNL = [A_listWNL A];
        B_listWNL = [B_listWNL 0];
    elseif RaA >= RaApitch && RaA < RaAhopf
        A_listWNL = [A_listWNL Astarnormal];
        B = sqrt(Astarnormal*(2*pi/G)*(r-rc)/FAstar);  
        B_listWNL = [B_listWNL B];
    end
end
% we need to add some stuff, as hopf happens later in WNL
A_listWNLADD = []; B_listWNLADD = []; r_listADD = [];
if hopfWNLr > r_list(end)
r_listADD = r_list(end):(hopfWNLr-r_list(end))/100:hopfWNLr;
for i=1:length(r_listADD)
    r = r_listADD(i);
    A_listWNLADD = [A_listWNLADD Astarnormal];
    B = sqrt(Astarnormal*(2*pi/G)*(r-rc)/FAstar);
    B_listWNLADD = [B_listWNLADD B];
end
end


%% make plots
% Full
figure()
plot(r_list,A_listFS,'b-','DisplayName', '$A_{FS}$'), hold on
plot(r_list,B_listFS,'r-','DisplayName','$B_{FS}$')
xlabel('$r$');
lgnd = legend('Location', 'Best');
title({'Full problem',['$Pr = ' PrT '$, $\Gamma = ' num2str(G) '$']})
%saveas(gcf,[figpath 'Full_G_' num2str(G) '.eps'], 'epsc')


% WNL
figure()
plot([r_list r_listADD],[A_listWNL A_listWNLADD],'b-','DisplayName', '$A_{WNL}$'), hold on
plot([r_list r_listADD],[B_listWNL B_listWNLADD],'r-','DisplayName','$B_{WNL}$')
xlabel('$r$');
lgnd = legend('Location', 'Best');
title({'Weakly non linear analysis',['$Pr = ' PrT '$, $\Gamma = ' num2str(G) '$']})
%saveas(gcf,[figpath 'WNL_G_' num2str(G) '.eps'], 'epsc')

% error
figure()
semilogy(r_list,abs(A_listFS./A_listWNL-1),'b-','DisplayName', '$|A_{FS}/A_{WNL}-1|$'), hold on
plot(r_list,abs(B_listFS./B_listWNL-1),'r-','DisplayName','$|B_{FS}/B_{WNL}-1|$')
xlabel('$r$');
lgnd = legend('Location', 'Best');
title({'Error',['$Pr = ' PrT '$, $\Gamma = ' num2str(G) '$']})
%saveas(gcf,[figpath 'Error_G_' num2str(G) '.eps'], 'epsc')
stop
%% Compare some time series
% do the DNS first
Ra = 836;
Pr = 0.02;
nu = sqrt(pi^3*Pr/Ra);
vTS = pi^2/nu;
path = '/Volumes/Samsung_T5/AR_2/32x32/Pr_0_02/Ra_8_36e2/';
kpsmodes1 = importdata([path 'Checks/kpsmodes1.txt']);
t = kpsmodes1(:,1); t = t*Pr^2/vTS;
ZeroOne = kpsmodes1(:,2); ZeroOne = ZeroOne/nu; ZeroOne = ZeroOne*sqrt(Pr);
OneOne = kpsmodes1(:,5); OneOne = OneOne/nu; OneOne =OneOne*4*G/(pi*(4+G^2)); % one 2 from c.c. and another from error that is in DNS
trange = [0.1 0.2];
%
figure()
subplot(2,1,1)
plot(t,OneOne)
xlim(trange)
xlabel('$\tau_E$')
ylabel('$A$')
%
subplot(2,1,2)
plot(t,ZeroOne)
xlim(trange )
xlabel('$\tau_E$')
ylabel('$Pr^{0.5}\widehat \psi_{0,1}$')
sgtitle('$Pr = 0.02,\,Ra = 836$, DNS')
%saveas(gcf,[figpath 'DNSTSComp.eps'], 'epsc')

%
% Now do model
%
% first bring back into coordinate system before transformation
b = a*(4+G^2)^2*pi^3/(2*G^3);
A = exp(WNLData.G_2.eps_0_02.r_1_5411163e4.theta)*a;
B = Pr^2*exp(WNLData.G_2.eps_0_02.r_1_5411163e4.phi)*b*sqrt(Pr);
t = (WNLData.G_2.eps_0_02.r_1_5411163e4.t).*b;
trange = [0.1 0.12];
%
figure()
subplot(2,1,1)
plot(t,A)
xlim(trange)
xlabel('$\tau_E$')
ylabel('$A$')
%
subplot(2,1,2)
plot(t,B)
xlim(trange )
xlabel('$\tau_E$')
ylabel('$Pr^{0.5}B$')
sgtitle('$Pr = 0.02,\,Ra = 836$, Model')
% %%saveas(gcf,[figpath 'ModelTSComp.eps'], 'epsc')
