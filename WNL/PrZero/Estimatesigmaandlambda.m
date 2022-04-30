addpath('/Users/philipwinchester/Dropbox/Matlab/Normal/Functions');
load('/Volumes/Samsung_T5/OldData/WNLZero.mat')
addpath('/Users/philipwinchester/Dropbox/Matlab/WNL/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrActuallyZero/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/PrZero/Functions')
addpath('/Users/philipwinchester/Dropbox/Matlab/Eigs_Solver/ForCluster/Functions')
G  = 2;
GS = GtoGS(G);
A_list = WNLZero.(GS).As;
sigma_list = WNLZero.(GS).sigmas;
lambda_list = abs(imag(WNLZero.(GS).Fs));
%% get ralpha
I = [];
for i=1:length(A_list)
  if 1e-6 <= A_list(i) && A_list(i) < 1e-2
    I = [I i]; 
  end
end
[~, ralpha, ~, ~, ~] = FitsPowerLaw(A_list(I),sigma_list(I)-sigma_list(1)); 


%% Do sigma
close all
sigmainf = sigma_list(end);
sigma0 = sigma_list(1);
% find Ac
f = (sigma_list-sigma0)./A_list;
ffunc = @(A) interp1(A_list,f,A);
[~,I] = max(f);
%Ac = A_list(I); % basically a points where they cross, A_list(I)
Ac = 2;
% [~,I] = min(abs(sigma_list));
% Ac = A_list(I);
fc = ffunc(Ac);
% get alpha and beta
%alpha = fc/Ac;
alpha = ralpha*(1-A_list/Ac)+(fc/Ac)*(A_list/Ac);
%beta = Ac*max(f);
beta = Ac*fc*(1-(A_list-Ac)./A_list)+(sigmainf-sigma0)*(A_list-Ac)./A_list;
%beta = sigmainf-sigma0;
%gamma = beta/Ac - fc;
% figure()
% plot(A_list,f), hold on
% plot(A_list,A_list.*alpha)
% plot(A_list,beta./A_list)
% xlim([0 10])
% ylim([0 200])

figure()
loglog(A_list,abs(sigma_list)), hold on
xlim([0 1000])
ylim([sigma0 sigmainf*2])
plot(A_list,abs(A_list.^2.*alpha+sigma0))
plot(A_list,abs(beta+sigma0)) 
