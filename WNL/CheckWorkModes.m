run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
fpath = '/Users/philipwinchester/Dropbox/Matlab/WNL/Functions';
addpath(fpath)
datapath = '/Volumes/Samsung_T5/OldData/WNLData.mat';
load(datapath)
load('/Volumes/Samsung_T5/OldData/NewSteadyState.mat');
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions')
load('/Volumes/Samsung_T5/OldData/PrZeroData.mat');

%%
N = 32;
n = [-(N/2):2:(N/2-1) -(N/2-1):2:(N/2-1)]; n = repmat(n, N/2);  n = n(1,:);
m = 1:N; m = repelem(m, N/2);
[~,~,n,m] = GetRemGeneral(n,m,N);
positionMatrix = MakePositionMatrix(n,m);

%%%
% This is a section to save what the normalised unstable eigenvector is at
% at the point where the odd modes becomes unstable. Note that according to
% the WNL, it is just the amplitude of the odd modes that change, not their
% direction vector
%%%
Pr = 1e-4; PrS = PrtoPrS(Pr);
G = 2; GS = GtoGS(G);
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
ThetaO1 = zeros(length(PsiO1),1);
for i=1:length(ThetaO1)
    ThetaO1(i) = PsiO1(i)*1i*(2*pi*n(i)/G)/((2*pi*n(i)/G)^2+(pi*m(i))^2);
end
ThetaO1 = ThetaO1/norm(ThetaO1);
% Now we want to get Theta01 and PsiO1 from DNS
D = GetFullMZeronss(Data,GS,PrS,1,"N_32x32");
signs = sign(D(2,:)); I = find(signs+1,1,"first");
RaAhopf = D(1,:); RaAhopf = RaAhopf(I);
type = ['N_' num2str(N) 'x' num2str(N)];
RaAS_list = string(fields(Data.(GS).(type).(PrS)));
errorpsi = zeros(1,length(RaAS_list));
errortheta = zeros(1,length(RaAS_list));
RaA_list = zeros(1,length(RaAS_list));
[~,~,nf,mf,~] = GetRemKeepnss_nxny(N,N); % f stands for full system
evenmodes = [];
for i=1:length(nf)
    if not(rem(nf(i) + mf(i),2))
        evenmodes = [evenmodes i];
    end
end
nf(evenmodes) = [];
mf(evenmodes) = [];
for k=1:length(RaAS_list)
    RaAS = RaAS_list(k);
    RaA = RaAStoRaA(RaAS); 
    RaA_list(k) = RaA;
    PsiO = Data.(GS).(type).(PrS).(RaAS).PsiE;
    ThetaO = 1i*Data.(GS).(type).(PrS).(RaAS).ThetaE; % add complex bit here
    PsiO(evenmodes) = []; % removing even modes
    ThetaO(evenmodes) = [];
    ThetaO1f = zeros(length(PsiO1),1);
    PsiO1f = zeros(length(PsiO1),1);
    % now fill ThetaO1f and PsiO1f. Could be done using position matrix, but
    % will do by hand. sign and complex might no line up with ThetaO1 and
    % PsiO1. But not going to worry about that. will just take the difference
    % in the abosolute value between modes. maybe it is worth beeing a
    % little more careful about this?
    for i=1:length(n)
        ninst = abs(n(i)); minst = m(i);
        % now do the search in PsiO and ThetaO
        for j=1:length(nf)
            if nf(j) == ninst && mf(j) == minst
                ThetaO1f(i) = ThetaO(j);
                PsiO1f(i) = PsiO(j);
                if n(i) < 0 % This probably wont do anytihng since pretty sure  ThetaO and PsiO are real. But put it in as it is the right thing to do.
                    ThetaO1f(i) = conj(ThetaO1f(i));
                    PsiO1f(i) = conj(PsiO1f(i));
                end
                break
            end
        end
    end
    % now normalise
    PsiO1f = PsiO1f/norm(PsiO1f);
    ThetaO1f = ThetaO1f/norm(ThetaO1f);
    % now we calculate error
    for i=1:length(n)
       %errorpsi(k) = errorpsi(k) + abs(abs(PsiO1f(i)) - abs(PsiO1(i)));
       %errortheta(k) = errortheta(k) + abs(abs(ThetaO1f(i)) - abs(ThetaO1(i)));
       errorpsi(k) = errorpsi(k) + max(abs(abs(PsiO1f(i))/abs(PsiO1(i))-1),abs(abs(PsiO1(i))/abs(PsiO1f(i))-1));
    end
end

%% Figures
r_list = RaA_list/Pr^2;
[r_list,I] = sort(r_list)
figure()
plot(r_list,errorpsi(I),'-o','MarkerSize',10)
ylabel('$\delta_{\psi}$')
xlabel('$r$')
%saveas(gcf,[figpath 'psierror'], 'epsc')
figure()
plot(r_list,errortheta(I),'-o','MarkerSize',10)
ylabel('$\delta_{\theta}$')
xlabel('$r$')
%saveas(gcf,[figpath 'thetaerror'], 'epsc')


%% Look at what the eigenvector is from the stability of SCRS
V = PrZeroData.G_2.N_32.Pr_1e_4.RaA_6_35e_4.Eigv;
PsiOS = V(1:175);
ThetaOS = V(176:end);
PsiOS = PsiOS/norm(PsiOS);
ThetaOS = ThetaOS/norm(ThetaOS);
PsiOS = real(PsiOS); % remove complex bit for readability
