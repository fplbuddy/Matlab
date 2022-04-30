%% Loading data
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
dt = 5e-3; dtS = normaltoS(dt,'dt',1);
Gy = 0.25; GyS = normaltoS(Gy,'Ly',1);
Ly = pi*Gy;
Ra = 8e6; RaS = normaltoS(Ra,'Ra',1);
Pr = 10; PrS = normaltoS(Pr,'Pr',1);
nu = sqrt(pi^3*Pr/Ra);
path = ['/Volumes/Samsung_T5/ForDist/IC_S/N_256x256/' PrS '/' RaS '/'  GyS '/' dtS];
kenergy2 = importdata([path '/Checks/kenergy2.txt']);
Z0An = importdata([path '/Checks/Z0An.txt']);
%%
ky = 1;
d = 1; %  height = d*pi
K2 = ky^2/d^2;
t = kenergy2(:,1);
ke = kenergy2(:,2);
clear kenergy2
NLterm = (Z0An(:,3) + Z0An(:,4))/K2;
ZO = Z0An(:,2);
clear Z0An
dis = -nu*(K2+(2*pi/Ly)^2)*ZO;
%%
figure()
plot(t,ZO,'DisplayName','$\widehat \psi^{\perp}_{0,1}$'), hold on
plot(t,NLterm,'DisplayName','$\eta\sqrt{<\psi^{\perp} \nabla^2 \psi^{\perp}>}$')
plot(t,dis,'DisplayName','$-\lambda \widehat \psi^{\perp}_{0,1}$')
xlim([0 100])
xlabel('$t$')
legend('Location','bestoutside')
saveas(gcf,[figpath 'ZOTSShort'], 'epsc')
%%
figure()
semilogy(t,abs(ZO),'DisplayName','$|\widehat \psi^{\perp}_{0,1}|$'), hold on
plot(t,abs(NLterm),'DisplayName','$|\eta\sqrt{<\psi^{\perp} \nabla^2 \psi^{\perp}>}|$')
plot(t,abs(dis),'DisplayName','$|-\lambda \widehat \psi^{\perp}_{0,1}|$')
xlim([0 10000])
xlabel('$t$')
legend('Location','bestoutside')
saveas(gcf,[figpath 'ZOTSLong'], 'epsc')

%%
figure()
histogram(NLterm./sqrt(ke))
title('$\eta$')
saveas(gcf,[figpath 'etahist'], 'epsc')
%%
figure()
plot(t(1:end-1),diff(ZO)/dt, 'DisplayName','Actual'), hold on
plot(t,NLterm+dis,'DisplayName','Predicted')
legend('Location','bestoutside')
