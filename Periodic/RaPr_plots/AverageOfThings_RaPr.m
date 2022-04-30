o1 = 1; o2 = 1;
f = 0; hnu = 1; 
fS = normaltoS(f, 'f'); hnuS = normaltoS(hnu, 'hnu');
o1S = normaltoS(o1, 'o1'); o2S = normaltoS(o2, 'o2');
run SetUp.m
n_list = ones(1,6)*1024;
nu_list = [5e-3 5e-3 5e-3 5e-3 5e-3 5e-3];
kappa_list = [2e-2 5e-3 2e-3 5e-4 2e-4 5e-5];
ken_list = zeros(1,length(kappa_list));
pen_list = zeros(1,length(kappa_list));
denk_list = zeros(1,length(kappa_list));
henk_list = zeros(1,length(kappa_list));
denp_list = zeros(1,length(kappa_list));
%nu_list = zeros(1,length(kappa_list));
%kappa_list = zeros(1,length(kappa_list));
for i=1:length(nu_list)
    nu = nu_list(i); kappa = kappa_list(i); n = n_list(i);
    nuS =normaltoS(nu, 'nu'); kappaS =normaltoS(kappa, 'kappa'); ns = ['n_' num2str(n)];
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

%% figures
figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(kappa_list,ken_list,'*','MarkerSize',MS)
ylabel('$\overline{<\psi \nabla^2 \psi>}$', 'FontSize', labelFS);
xlabel('$\kappa$', 'FontSize', labelFS);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,[figpath 'Average_Kinetic_Energy_kappa'], 'epsc')

figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(kappa_list,pen_list,'*','MarkerSize',MS)
ylabel('$\overline{<\theta^2>}$', 'FontSize', labelFS);
xlabel('$\kappa$', 'FontSize', labelFS);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,[figpath 'Average_Potential_Energy_kappa'], 'epsc')

figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(kappa_list,denk_list.*nu_list,'*','MarkerSize',MS)
ylabel('$\nu \overline{<\psi \nabla^4 \psi>}$', 'FontSize', labelFS);
xlabel('$\kappa$', 'FontSize', labelFS);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,[figpath 'Average_SSDKE_nu_kappa'], 'epsc')

figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(kappa_list,henk_list,'*','MarkerSize',MS)
ylabel('$\mu \overline{<\psi^2>}$', 'FontSize', labelFS);
xlabel('$\kappa$', 'FontSize', labelFS);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,[figpath 'Average_LSDKE_kappa'], 'epsc')

figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(kappa_list,denp_list.*kappa_list,'*','MarkerSize',MS)
ylabel('$\kappa \overline{<\theta \nabla^2 \theta>}$', 'FontSize', labelFS);
xlabel('$\kappa$', 'FontSize', labelFS);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,[figpath 'Average_SSDPE_kappa_kappa'], 'epsc')

figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(kappa_list,denk_list.*nu_list,'*','MarkerSize',MS)
ylabel('$\overline{<\psi \nabla^4 \psi>}$', 'FontSize', labelFS);
xlabel('$\kappa$', 'FontSize', labelFS);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,[figpath 'Average_SSDKE_nonu_kappa'], 'epsc')

figure('Renderer', 'painters', 'Position', [5 5 540 200])
loglog(kappa_list,denp_list,'*','MarkerSize',MS)
ylabel('$\overline{<\theta \nabla^2 \theta>}$', 'FontSize', labelFS);
xlabel('$\kappa$', 'FontSize', labelFS);
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
saveas(gcf,[figpath 'Average_SSDPE_nokappa_kappa'], 'epsc')



