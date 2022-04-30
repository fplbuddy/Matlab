run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
figpath  = '/Users/philipwinchester/Desktop/Figures/SpecPaper/';
o1 = 1; o2 = 1; 
nu = 2e-5; kappa = 2e-5; f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
nuS = normaltoS(nu,'nu',1); kappaS = normaltoS(kappa,'kappa',1);
n = 1024*4;
ns = ['n_' num2str(n)];
path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
spath = [path '/Spectra/'];
times = importdata([spath 'spec_times.txt']);
kenergy = importdata([path '/Checks/kenergy.txt']);
t = kenergy(:,1);
trans = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).trans;
tcrit = t(trans);
[~,Pflux] = GetFluxes(path,tcrit);

top = floor(n/3);
k = 1:top;
logk = log(k);
logPflux = log(abs(Pflux(1:top)));
grad = gradient(logPflux(:)) ./ gradient(logk(:));
%% Get kb's
thresh = 1/3;
for i=1:top
   if abs(grad(i)) < thresh
      kb1 = i;
      break
   end
end

for i=kb1:top
   if abs(grad(i)) > thresh
      kb2 = i;
      break
   end
end

%%

figure()
%loglog(abs(diff(logPflux)./diff(logk)))
loglog(abs(grad),'b'), hold on
ylim([1e-2 10])

xticks([1 kb1 10 kb2 10^3])
xticklabels(["$10^0$" "$k_{b_1}$" "$10^1$" "$k_{b_2}$" "$10^3$"])
% plot boundaries
plot([kb1 kb1], [1e-2 1e1],'k--','HandleVisibility','off')
plot([kb2 kb2], [1e-2 1e1],'k--','HandleVisibility','off')
xlabel('$k$')
ylabel('$\left| \frac{d \log{\Pi^{\theta}(k)}}{d \log{k}} \right|$')
saveas(gcf,[figpath 'NV_ConstantFlux'], 'epsc')
