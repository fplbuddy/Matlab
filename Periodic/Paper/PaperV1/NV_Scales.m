run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
figpath  = '/Users/philipwinchester/Desktop/Figures/SpecPaper/';
%%
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
[euuresult,fenresult,denresult,henresult] = GetKineticScales(path,tcrit);

%% Get where k_as are
%thresh = 0.1;
check = abs(euuresult./fenresult);
for j=1:length(check)
    if abs(euuresult(j)) > abs(henresult(j)*hnu)
        k1 = j;
        break
    end
end


check = abs(euuresult./fenresult);
for j=k1+1:length(check)
    if abs(denresult(j)*nu) > abs(euuresult(j))
        k2 = j;
        break
    end
end

for j=k2+1:length(check)
    if abs(euuresult(j)) > abs(fenresult(j))
        k3 = j;
        break
    end
end



%% plot
figure()
loglog(1:length(euuresult),abs(euuresult), 'g', 'Displayname','$|T|$'), hold on
loglog(1:length(fenresult),abs(fenresult), 'b', 'Displayname','$|B|$')
loglog(1:length(denresult),abs(denresult*nu), 'r', 'Displayname','$|S|$')
loglog(1:length(henresult),abs(henresult*hnu), 'm', 'Displayname','$|L|$')
lgnd = legend('Location', 'best');

xlim([1 n/3])
ylim([1e-9 1e-1])
yticks([1e-9 1e-7 1e-5 1e-3 1e-1])

% plot boundaries
plot([k1 k1], [1e-9 1e-1],'k--','HandleVisibility','off')
plot([k2 k2], [1e-9 1e-1],'k--','HandleVisibility','off')
plot([k3 k3], [1e-9 1e-1],'k--','HandleVisibility','off')

xticks([1 k1 10 10^2 k2 k3 10^3])
xticklabels(["$10^0$" "$k_{a_1}$" "$10^1$" "$10^2$" "$k_{a_2}$" "$k_{a_3}$" "$10^3$"])

% put roman numerals in 
ypos1 = 5e-9;
ypos2 = 1e-2;
scale = 1.2;
text(1*scale,ypos1,'\uppercase\expandafter{\romannumeral 1\relax}', 'FontSize', numFS)
text(k1*scale,ypos1,'\uppercase\expandafter{\romannumeral 2\relax}', 'FontSize', numFS)
text(k2*scale,ypos1,'\uppercase\expandafter{\romannumeral 3\relax}', 'FontSize', numFS)
text(k3*scale,ypos1,'\uppercase\expandafter{\romannumeral 4\relax}', 'FontSize', numFS)


xlabel('$k$')
saveas(gcf,[figpath 'NV_Scales'], 'epsc')




