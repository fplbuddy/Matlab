run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
close all
figure()
o1 = 4; o2 = 1;
%nu = 2e-3; kappa = 2e-3; 
f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
% nuS = normaltoS(nu,'nu',1); kappaS = normaltoS(kappa,'kappa',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
ns_list = string(fields(AllData));
for i=1:length(ns_list)
   ns = ns_list(i);
   try
   nuS_list = string(fields(AllData.(ns).(o1S).(o2S).(fS).(hnuS)));
   for j=1:length(nuS_list)
    nuS = nuS_list(j);
    kappaS_list = string(fields(AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS)));
    for k=1:length(kappaS_list)
       kappaS =  kappaS_list(k);
       kappa = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).kappa;
       nu = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).nu;
       Pr = nu/kappa;
       Ra = (2*pi)^(4*o1-1)/(nu*kappa);
       loglog(Pr,Ra,'b*','MarkerSize',10,'HandleVisibility','off'), hold on
    end
   end
   catch
   end
end
title(['$n=' num2str(o1) '$'])
ylabel('$Ra$')
xlabel('$Pr$')
xlim([1e-2 1e2])
ylim([1e45 1e50])
yticks([1e45 1e46 1e47 1e48 1e49 1e50])
% some extra lines
Ramax = (2*pi)^(o1*4-1)/(1e-19)^2;
plot([1e-2 1e2],[Ramax Ramax],'-r','DisplayName','$Ra$ constant')
plot([1e-2 1e2],[Ramax/1e4 Ramax],'-k','DisplayName','$\nu$ constant')
plot([1e-2 1e2],[Ramax Ramax/1e4 ],'-g','DisplayName','$\kappa$ constant')
legend('Location','bestoutside')
saveas(gcf,[figpath 'RaVsPr_n' num2str(o1)], 'epsc')


