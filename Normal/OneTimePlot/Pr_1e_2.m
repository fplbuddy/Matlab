ARS = 'AR_2';
PrS = 'Pr_0_1';
RaS = 'Ra_2e9';
run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);


figure()
semilogy(kpsmodes1(:,1),kenergy(:,2),'DisplayName','$\frac{1}{2}<\psi_x^2 + \psi_y^2>$'), hold on
plot(kpsmodes1(:,1),(kpsmodes1(:,3).^2+kpsmodes1(:,5).^2)*4,'DisplayName','$|\widehat \psi_{1,1}|^2$')
plot(kpsmodes1(:,1),kpsmodes1(:,2).^2,'DisplayName','$\frac{1}{4}|\widehat \psi_{0,1}|^2$')
lgnd = legend();
xlabel('$t\,(s)$')
title('$Pr = 10^{-1},\,Ra = 2 \times 10^9$')
% ylim([2e-2 100])
% Ra = 2e9;
% Pr = 0.01;
% nu = sqrt(pi^3*Pr/Ra);
% t1 = 2000;
% y1 = 56;
% t2 = 4500;
% A = y1/exp(-2*nu*t1);
% y2 = A*exp(-2*nu*t2);
% plot([t1 t2], [y1 y2],'r--','DisplayName','$\propto e^{-2\nu t}$');
% 
% axes('Position',[.5 .5 .4 .2])
% box on
% semilogy(kpsmodes1(:,1),kenergy(:,2),'DisplayName','$\frac{1}{2}<\psi_x^2 + \psi_y^2>$'), hold on
% plot(kpsmodes1(:,1),(kpsmodes1(:,3).^2+kpsmodes1(:,5).^2)*4,'DisplayName','$|\widehat \psi_{1,1}|^2$')
% plot(kpsmodes1(:,1),kpsmodes1(:,2).^2,'DisplayName','$\frac{1}{4}|\widehat \psi_{0,1}|^2$')
% plot([t1 t2], [y1 y2],'r--','DisplayName','$\propto e^{-2\nu t}$');
% ylim([52 58]);
% xlim([2500 4500]);
% set(gca,'xtick',[])
% set(gca,'xticklabel',[])
% set(gca,'ytick',[])
% set(gca,'yticklabel',[])

