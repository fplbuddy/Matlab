run /Users/philipwinchester/Dropbox/Matlab/GeneralFuncs/SetUp.m
Pr_list = [Inf 100 10 3 1 0.3 0.1];
cols = distinguishable_colors(length(Pr_list));
GyC_list = zeros(length(Pr_list),1);
Ra = 2e9; type = 'Shearing';
Nx = 1024; Ny = 512;
for j=1:length(Pr_list)
    Pr = Pr_list(j); PrS = normaltoS(Pr,'Pr',1);
    if Pr == 1
        path = AllData.IC_S.N_1024x512.Pr_1e0.Ra_2e9.Ly_1e_1.path; 
       kenergy2 = importdata([path '/Checks/penergy2.txt']);
       t = kenergy2(:,1); s = kenergy2(:,2);
       [alpha, ~, ~, ~, ~] = Fitslogy(t,s);
       GyC = CritLyPr1(Ra,alpha,0.1);
        GyC_list(j) = GyC/pi;
    elseif Pr == Inf
        [GyC,~,~] = CritLyFromData(Ra,Pr,'NonShearing', Nx,Ny,AllData);
        GyC_list(j) = GyC;
    else
    [GyC,~,~] = CritLyFromData(Ra,Pr,type, Nx,Ny,AllData);
    % add to plot
    GyC_list(j) = GyC;
    end
end

%% get the other things we may want to plot against
ken_list = zeros(length(Pr_list),1);
pen_list = zeros(length(Pr_list),1);
Ex_list = zeros(length(Pr_list),1);
Ey_list = zeros(length(Pr_list),1);
ZeroOne_list = zeros(length(Pr_list),1);
%
ARS = 'AR_2'; RaS = RatoRaS(Ra);
for i=1:length(Pr_list)
    Pr = Pr_list(i); PrS = PrtoPrS(Pr);
    try
    ken_list(i) = AllData.(ARS).(PrS).(RaS).calcs.ken;
    Ex_list(i) = AllData.(ARS).(PrS).(RaS).calcs.Ex;
    Ey_list(i) = AllData.(ARS).(PrS).(RaS).calcs.Ey; 
    ZeroOne_list(i) = AllData.(ARS).(PrS).(RaS).calcs.ZeroOne;
    catch
    end
    pen_list(i) = AllData.(ARS).(PrS).(RaS).calcs.pen;
end
% storing data and  the things to go with it 
AllLists.ken_list.data = ken_list;
AllLists.ken_list.xlab = 'Kinetic Energy';
AllLists.ken_list.gotinf = 0;

AllLists.Ex_list.data = Ex_list;
AllLists.Ex_list.xlab = '$E_x$';
AllLists.Ex_list.gotinf = 0;

AllLists.Ey_list.data = Ey_list;
AllLists.Ey_list.xlab = '$E_y$';
AllLists.Ey_list.gotinf = 0;

AllLists.pen_list.data = pen_list;
AllLists.pen_list.xlab = 'Potential Energy';
AllLists.pen_list.gotinf = 1;

AllLists.ZeroOne_list.data = ZeroOne_list;
AllLists.ZeroOne_list.xlab = 'Average $\widehat\psi_{0,1}$';
AllLists.ZeroOne_list.gotinf = 0;

%% Make some plots
plots_list = string(fields(AllLists));
for i= 1:length(plots_list)
    figure()
    plt = plots_list(i);
    data = AllLists.(plt).data;
    for j=1:length(Pr_list)
        Pr = Pr_list(j);
        col = cols(j,:);
        if Pr == Inf && AllLists.(plt).gotinf
            plot(data(j), GyC_list(j), '.','Color',col,'DisplayName','$\infty$'), hold on
        elseif Pr ~= Inf
            plot(data(j), GyC_list(j), '.','Color',col,'DisplayName',num2str(Pr)), hold on
        end
    end
    %lgnd = legend('Location', 'Bestoutside', 'FontSize', numFS);
    lgnd = legend();
    title(lgnd,'Pr')
    xlabel(AllLists.(plt).xlab);
    ylabel('Critical $\Gamma_y$')
    forsave = replace(AllLists.(plt).xlab,' ', '_');
    forsave = replace(forsave,'\', '');
    forsave = replace(forsave,'$', '');
    saveas(gcf,[figpath forsave '_GyC'], 'epsc')
end





%lgnd = legend('Location', 'Bestoutside', 'FontSize', numFS);
%title(lgnd,'$Pr$', 'FontSize', numFS)
% ax = gca;
% ax.XAxis.FontSize = numFS;
% ax.YAxis.FontSize = numFS;
% ax = gca;
% ax.XAxis.FontSize = numFS;
% ax.YAxis.FontSize = numFS;
% ylabel('Crit $\Gamma_{y}$','FontSize',labelFS)
% xlabel('$Pr$','FontSize',labelFS)
% RaT = RatoRaT(Ra); 
% title(['$Ra=' RaT '$'], 'FontSize',labelFS)
%saveas(gcf,[figpath 'GyC_' RaS  '_manyPr_' type], 'epsc')