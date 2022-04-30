run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
n = 1;
nu = 2e-4;
mu = 1;

lowestRa = ((2*pi)^(4*n)*(1+mu/nu))


% Ra = (2*pi)^(4*n)*(1+mu/nu);
% 
% kappa = (2*pi)^3/(nu*Ra);
% 
% Pr = nu/kappa
% 
% Ratop = (2*pi)^3/(nu^2*1e-3);




%% Make matrix
% n = 1;
% m = 0;
% nu = 5e-3;
% kappa = 5e-2;
% Pr = nu/kappa;
% Ra = (2*pi)^3/(nu*kappa);
% mu = 1;
% Rh = mu*(2*pi)^(2*(n+m))/nu;
% K2 = (2*pi)^2;
% M = [-Pr*K2^n-Pr*Rh*K2^(-m) -1i*2*pi*Ra*Pr*K2^(-1); 1i*2*pi -K2^n];
% sig = eigs(M);
% 2*max(sig)*kappa/(2*pi)^(2*n)


%% Solve quadratic
over = 10;
Pr = 1e-3;
n = 1;
%mu_list = logspace(0, -3, 50);
mu_list = [0.5 1];
nu_list = zeros(length(mu_list),1);
Rac_list = zeros(length(mu_list),1);
Ramin_list = zeros(length(mu_list),1);
for i=1:length(mu_list)
   mu = mu_list(i);
   p = [2*over*pi 2*over*pi*mu -Pr];
   nu = max(roots(p));
   nu_list(i) = nu;
   Rac = (2*pi)^(4*n)*(1+mu/nu);
   Rac_list(i) = Rac;
   kappa = nu/Pr;
   Ramin_list(i) = (pi*2)^3/(nu*kappa);
   kappa = nu*Pr;
   Ramax_list(i) = (pi*2)^3/(nu*kappa);
end
figure()
grid on
subplot(1,2,1)
loglog(mu_list,Rac_list, 'MarkerSize',10,'DisplayName','$Ra_c$'), hold on
loglog(mu_list,Ramin_list, 'MarkerSize',10,'DisplayName','$Ra_{min}$')
loglog(mu_list,Ramax_list, 'MarkerSize',10,'DisplayName','$Ra_{max}$')
xticks([1e-3 1e-2 1e-1 1])
xlabel('$\mu$')
legend()
subplot(1,2,2)
loglog(mu_list,nu_list, 'MarkerSize',10)
xticks([1e-3 1e-2 1e-1 1])
xlabel('$\mu$')
ylabel('$\nu$')
sgtitle('$Pr \in [10^{-3}, 10^3]$')
%saveas(gcf,[figpath 'Pr_1e_3'], 'epsc')
%%
Pr = 1e-2;
n = 1;
nu_list = zeros(length(mu_list),1);
Rac_list = zeros(length(mu_list),1);
Ramin_list = zeros(length(mu_list),1);
for i=1:length(mu_list)
   mu = mu_list(i);
   p = [2*over*pi 2*over*pi*mu -Pr];
   nu = max(roots(p));
   nu_list(i) = nu;
   Rac = (2*pi)^(4*n)*(1+mu/nu);
   Rac_list(i) = Rac;
   kappa = nu/Pr;
   Ramin_list(i) = (pi*2)^3/(nu*kappa);
   kappa = nu*Pr;
   Ramax_list(i) = (pi*2)^3/(nu*kappa);
end
figure()
grid on
subplot(1,2,1)
loglog(mu_list,Rac_list, 'MarkerSize',10,'DisplayName','$Ra_c$'), hold on
loglog(mu_list,Ramin_list, 'MarkerSize',10,'DisplayName','$Ra_{min}$')
loglog(mu_list,Ramax_list, 'MarkerSize',10,'DisplayName','$Ra_{max}$')
xticks([1e-3 1e-2 1e-1 1])
xlabel('$\mu$')
legend()
subplot(1,2,2)
loglog(mu_list,nu_list, 'MarkerSize',10)
xticks([1e-3 1e-2 1e-1 1])
xlabel('$\mu$')
ylabel('$\nu$')
sgtitle('$Pr \in [10^{-2}, 10^2]$')
%saveas(gcf,[figpath 'Pr_1e_2'], 'epsc')
