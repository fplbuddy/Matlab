addpath('/Users/philipwinchester/Dropbox/Matlab/GeneralFuncs')
run SetUp.m
path = '/Volumes/Samsung_T5/OldData/NewSteadyState.mat';
load(path)
Pr_list = [1e-4 6e-5 3e-5 2e-5 1e-5];
PsiMiss_list = zeros(1,length(Pr_list));
ThetaMiss_list = zeros(1,length(Pr_list));
PsiOdd_list = zeros(1,length(Pr_list));
ThetaOdd_list = zeros(1,length(Pr_list));
PsiOneOne_list = zeros(1,length(Pr_list));
ThetaOneOne_list = zeros(1,length(Pr_list));
ThetaZeroTwo_list = zeros(1,length(Pr_list));
r = 1.02e-3/(1e-4)^2; % approx when hopf happens
for j=1:length(Pr_list)
Pr = Pr_list(j);
RaA = r*Pr^2;
RaA = round(RaA, 3, 'significant');
G = 2; Nx = 32; Ny = 32;
res = ['N_' num2str(Nx) 'x' num2str(Ny)];
GS = ['G_' num2str(G)]; RaAS = normaltoS(RaA,'RaA',1);
% PrS = ['Pr_' replace(num2str(Pr),'.','_')];
%PrS = replace(PrS,'-','_');
PrS = PrtoPrS(Pr);
eigV = Data.(GS).(res).(PrS).(RaAS).eigv; 
PsiV = eigV(1:length(eigV)/2); ThetaV = eigV(length(eigV)/2+1:end);
n = [(-Nx/2):(Nx/2-1)]; n = repmat(n, Ny);  n = n(1,:);
m = 1:Ny; m = repelem(m, Nx);
[~,~,n,m] = GetRemGeneral_nxny(n,m,Nx,Ny);
% normalise functions
PsiV = PsiV/norm(PsiV);
ThetaV = ThetaV/norm(ThetaV);
% now find widehat proportion is nor caught
PsiMiss = 0;
ThetaMiss = 0;
PsiOdd = 0;
ThetaOdd = 0;
PsiOneOne = 0;
ThetaOneOne = 0;
ThetaZeroTwo = 0;
for i=1:length(n)
    % want to add even modes that are not 1,1
    if not(rem(abs(n(i))+m(i),2)) && not(abs(n(i)) == 1 && m(i) == 1)
        PsiMiss = PsiMiss + abs(PsiV(i))^2;
        if not(abs(n(i)) == 0 && m(i) == 2) % remove 0,2 from theta
            ThetaMiss = ThetaMiss + abs(ThetaV(i))^2;
        end
    elseif rem(abs(n(i))+m(i),2) % odd modes
        PsiOdd = PsiOdd + abs(PsiV(i))^2;
        ThetaOdd = ThetaOdd + abs(ThetaV(i))^2;
    elseif abs(n(i)) == 1 && m(i) == 1 %1,1
        PsiOneOne = PsiOneOne + abs(PsiV(i))^2;
        ThetaOneOne = ThetaOneOne + abs(ThetaV(i))^2;
    end 
    if abs(n(i)) == 0 && m(i) == 2 % 0,2 for theta
        ThetaZeroTwo = ThetaZeroTwo + abs(ThetaV(i))^2;
    end
end
PsiMiss_list(j) = PsiMiss;
ThetaMiss_list(j) = ThetaMiss;
PsiOdd_list(j) = PsiOdd;
ThetaOdd_list(j) = ThetaOdd;
PsiOneOne_list(j) = PsiOneOne;
ThetaOneOne_list(j) = ThetaOneOne;
ThetaZeroTwo_list(j) = ThetaZeroTwo;
end
%% figure
figure()
loglog(Pr_list,PsiOneOne_list,'b-o','MarkerSize',10,'DisplayName','$\left|\widehat \psi_{1,1} \right|^2$'), hold on
loglog(Pr_list,PsiOdd_list,'r-o','MarkerSize',10,'DisplayName','$\sum_{Odd Modes}  \left|\widehat\psi_{k_x,k_y}\right|^2$')
loglog(Pr_list,PsiMiss_list,'k-o','MarkerSize',10,'DisplayName','$\sum_{Remaining}  \left|\widehat\psi_{k_x,k_y}\right|^2$')
legend('Location','bestoutside')
xlabel('$Pr$')
% guide the eye
alpha = 2;
x1 = 2e-5;
x2 = 6e-5;
y1 = 1e-9;
A = y1/x1^alpha;
y2 = A*x2^alpha;
plot([x1 x2], [y1 y2], '--k','DisplayName',['$Pr^' num2str(alpha) '$'])
%
%
%
figure()
loglog(Pr_list,ThetaOneOne_list,'b-o','MarkerSize',10,'DisplayName','$\left|\widehat \theta_{1,1} \right|^2$'), hold on
loglog(Pr_list,ThetaOdd_list,'r-o','MarkerSize',10,'DisplayName','$\sum_{Odd Modes}  \left|\widehat\theta_{k_x,k_y}\right|^2$')
loglog(Pr_list,ThetaZeroTwo_list,'g-o','MarkerSize',10,'DisplayName','$\left|\widehat \theta_{0,2} \right|^2$')
loglog(Pr_list,ThetaMiss_list,'k-o','MarkerSize',10,'DisplayName','$\sum_{Remaining}  \left|\widehat\theta_{k_x,k_y}\right|^2$')
legend('Location','bestoutside')
xlabel('$Pr$')
saveas(gcf,[figpath 'PsiModeScaling'], 'epsc')
% guide the eye
alpha = 2;
x1 = 2e-5;
x2 = 6e-5;
y1 = 1e-9;
A = y1/x1^alpha;
y2 = A*x2^alpha;
plot([x1 x2], [y1 y2], '--k','DisplayName',['$Pr^' num2str(alpha) '$'])
saveas(gcf,[figpath 'ThetaModeScaling'], 'epsc')

