fpath = '/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions/';
addpath(fpath)
% Loading in the old data
% dpath = '/Volumes/Samsung_T5/OldData/masternew.mat';
load(dpath);

Nx = 400;
Ny = 400;
Pr = 1e6; PrS = PrtoPrS(Pr);
Ra = 2.6e7; RaS = RatoRaS(Ra);
type = ['OneOne' num2str(Nx)];

ThetaE = Data.AR_2.(type).(PrS).(RaS).ThetaE;
[~,~,n,m] = GetRemKeep_nxny(Nx,Ny,1);
k = sqrt(Nx^2*(n.^2/Nx^2 + m.^2/(4*Ny^2)));
kmax = ceil(max(k));
energylist = zeros(1+kmax,1);
for i=1:length(n)
   ninst = n(i); minst = m(i);
   kcheck = k(i);
   pos = floor(kcheck);
   add = ThetaE(i)^2;
   if n ~= 0
       add = add*2;
   end
   energylist(pos) = energylist(pos) + add;   
end
figure()
semilogy(0:kmax,energylist)

% do spectrum in ky
% energylist = zeros(max(m),1);
% for i=1:length(n)
%    minst = m(i);
%    pos = floor(minst);
%    add = ThetaE(i)^2;
%    if n ~= 0
%        add = add*2;
%    end
%    energylist(pos) = energylist(pos) + add;   
% end
%semilogy(1:max(m),energylist)
FS = 20;
numFS = 16;
%xlabel('$k_y$','FontSize', FS)
%ylabel('$\sum_{k_x} |\theta_{k_x,k_y}|^2$','FontSize', FS)

xlabel('$k = N_x\sqrt{k_x^2/N_x^2+k_y^2/(4N_y^2)}$','FontSize', FS)
ylabel('$\sum_{k} |\theta_{k_x,k_y}|^2$','FontSize', FS)
ax = gca;
ax.XAxis.FontSize = numFS;
title('$N_x = 400, N_y = 400$', 'FontSize', FS)
ax.YAxis.FontSize = numFS;
%%
Nx = 512;
Ny = 128;
Pr = 1e6; PrS = PrtoPrS(Pr);
Ra = 2.6e7; RaS = RatoRaS(Ra);
type = ['OneOne' num2str(Nx)];

ThetaE = Data.AR_2.(type).(PrS).(RaS).ThetaE;
[~,~,n,m] = GetRemKeep_nxny(Nx,Ny,1);
k = sqrt(Nx^2*(n.^2/Nx^2 + m.^2/(4*Ny^2)));
kmax = ceil(max(k));
energylist = zeros(1+kmax,1);
for i=1:length(n)
   kcheck = k(i);
   pos = floor(kcheck);
   add = ThetaE(i)^2;
   if n ~= 0
       add = add*2;
   end
   energylist(pos) = energylist(pos) + add;   
end
figure()
semilogy(0:kmax,energylist)
xlabel('$k = N_x\sqrt{k_x^2/N_x^2+k_y^2/(4N_y^2)}$','FontSize', FS)
ylabel('$\sum_{k} |\theta_{k_x,k_y}|^2$','FontSize', FS)
ax = gca;
ax.XAxis.FontSize = numFS;
title('$N_x = 512, N_y = 128$', 'FontSize', FS)
ax.YAxis.FontSize = numFS;
