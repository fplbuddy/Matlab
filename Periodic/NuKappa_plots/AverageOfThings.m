run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Vary = "kappa";
o1 = 1; o2 = 0;
f = 0; hnu = 1; 
fS = normaltoS(f, 'f',1); hnuS = normaltoS(hnu, 'hnu',1);
o1S = normaltoS(o1, 'o1',1); o2S = normaltoS(o2, 'o2',1);
n_list = ones(1,5)*1024;
nu_list = [5e-3 5e-3 5e-3 5e-3];
kappa_list = [5e-5 1e-4 5e-4 5e-2];
ken_list = zeros(1,length(kappa_list));
pen_list = zeros(1,length(kappa_list));
denk_list = zeros(1,length(kappa_list));
henk_list = zeros(1,length(kappa_list));
denp_list = zeros(1,length(kappa_list));
%nu_list = zeros(1,length(kappa_list));
%kappa_list = zeros(1,length(kappa_list));
for i=1:length(nu_list)
    nu = nu_list(i); kappa = kappa_list(i); n = n_list(i);
    nuS =normaltoS(nu, 'nu',1); kappaS =normaltoS(kappa, 'kappa',1); ns = ['n_' num2str(n)];
    path = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).path;
    kenergy = importdata([path '/Checks/kenergy.txt']);
    penergy = importdata([path '/Checks/penergy.txt']);
    trans = AllData.(ns).(o1S).(o2S).(fS).(hnuS).(nuS).(kappaS).trans;
    t = kenergy(:,1); t = t(trans:end);
    ken =  kenergy(:,2); ken = ken(trans:end);
    denk =  kenergy(:,3); denk = denk(trans:end);
    henk =  kenergy(:,5); henk = henk(trans:end);
    pen =  penergy(:,2); pen = pen(trans:end);
    denp =  penergy(:,3); denp = denp(trans:end);
    ken_list(i) = MyMeanEasy(ken,t);
    pen_list(i) = MyMeanEasy(pen,t);
    denk_list(i) = MyMeanEasy(denk,t);
    denp_list(i) = MyMeanEasy(denp,t);
    henk_list(i) = hnu*MyMeanEasy(henk,t);
    %nu_list(i) = nu;
    %kappa_list(i) = kappa;
end
if Vary == "kappa"
    Vary = kappa_list;
    constnumS = normaltoS(nu_list(end),'nu',1);
    tit = ['Varykappa_'  constnumS '_m_' num2str(o2)];
    xlab = '$\kappa$';
else
    Vary = nu_list;
    constnumS = normaltoS(nu_list(end),'nu',1);
    tit = ['Varynu_kappa' constnumS '_m_' num2str(o2)];
    xlab = '$\nu$';
end

%% figures
figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(Vary,ken_list,'*','MarkerSize',MS/3)
ylabel('$\overline{<\psi \nabla^2 \psi>}$', 'FontSize', labelFS);
xlabel(xlab, 'FontSize', labelFS);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,[figpath 'Average_Kinetic_Energy_' tit], 'epsc')

figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(Vary,pen_list,'*','MarkerSize',MS/3)
ylabel('$\overline{<\theta^2>}$', 'FontSize', labelFS);
xlabel(xlab, 'FontSize', labelFS);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,[figpath 'Average_Potential_Energy_' tit], 'epsc')

figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(Vary,denk_list,'*','MarkerSize',MS/3)
ylabel('$\overline{<\psi \nabla^4 \psi>}$', 'FontSize', labelFS);
xlabel(xlab, 'FontSize', labelFS);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,[figpath 'Average_SSDKE_' tit], 'epsc')

figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(Vary,henk_list,'*','MarkerSize',MS/3)
ylabel('$\overline{<\psi^2>}$', 'FontSize', labelFS);
xlabel(xlab, 'FontSize', labelFS);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,[figpath 'Average_LSDKE_' tit], 'epsc')

figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(Vary,denp_list,'*','MarkerSize',MS/3)
ylabel('$\overline{<\theta \nabla^2 \theta>}$', 'FontSize', labelFS);
xlabel(xlab, 'FontSize', labelFS);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,[figpath 'Average_SSDPE_' tit], 'epsc')




