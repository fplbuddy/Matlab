run SetUp.m
%%
dpath = '/Volumes/Samsung_T5/OldData/PrZeroData.mat';
load(dpath);
PrS = "Pr_1e_2";
RaAS_list = string(fields(PrZeroData.G_2.N_32.(PrS)));
RaC = 8*pi^4;
[RaAS_list,~] = OrderRaAS_list(RaAS_list);
RaA_list = [0];
OneOne_list = [0];
ZeroOne_list = [0];
for i=1:length(RaAS_list)
    RaAS = RaAS_list(i);
    RaA = RaAStoRaA(RaAS);
    if RaA < 6.14
    Psi = PrZeroData.G_2.N_32.(PrS).(RaAS).PsiE;
    OneOne_list = [OneOne_list abs(Psi(1))];
    ZeroOne_list = [ZeroOne_list 0];
    %Ra = RaC + RaA;
    RaA_list = [RaA_list RaA];
    end
end
% other 
dpath = '/Volumes/Samsung_T5/OldData/NewSteadyState.mat';
load(dpath);
PrS = "Pr_0_01";
RaAS_list = string(fields(Data.G_2.N_64x64.(PrS)));
[RaAS_list,~] = OrderRaAS_list(RaAS_list);
for i=1:length(RaAS_list)
    RaAS = RaAS_list(i);
    RaA = RaAStoRaA(RaAS);
    if RaA < 10
        Psi = Data.G_2.N_64x64.(PrS).(RaAS).PsiE;
        OneOne_list = [OneOne_list abs(Psi(2))];
        ZeroOne_list = [ZeroOne_list abs(Psi(1))];
        RaA_list = [RaA_list RaA];
    end
end

figure('Renderer', 'painters', 'Position', [5 5 900 200])
xstart = 0.05;
width = 0.28;
height = 0.61;
dif = 0.04;
ystart = 0.25;
subplot(1,3,1)
set(subplot(1,3,1), 'Position', [xstart, ystart, width, height])
plot(RaA_list, OneOne_list, 'Color','blue'), hold on
plot(RaA_list, ZeroOne_list, 'Color','red')
%xlim([RaC 789])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xticks([0 2 4 6.14 8 10])
xlim([0 9.48])
xticklabels(["0" "2" "4" "$\delta Ra_{c}$" "8" "10"])
text(780-RaC, 0.15, '$| \widehat \psi_{1,1}|$', 'Color', 'blue', 'FontSize',LabelFS)
text(785-RaC, 0.05, '$| \widehat \psi_{0,1}|$', 'Color', 'red', 'FontSize',LabelFS)
xlabel('$\delta Ra$','FontSize', LabelFS)
text(0.2, 0.224, '(a)', 'Color', 'black', 'FontSize',LabelFS)
%title('(a)', 'FontSize',LabelFS)


%% non-linear 1
kpsmodes1 = importdata('/Volumes/Samsung_T5/AR_2/32x32/Pr_0_01/Ra_7_9e2/Checks/kpsmodes1.txt');
Ra = 790;
Pr = 0.01;
kappa = sqrt((pi)^3/(Ra*Pr));
t = kpsmodes1(:,1);
OneOne = 2*sqrt(kpsmodes1(:,3).^2 + kpsmodes1(:,5).^2); % 2 as we have messed up the DNS
ZeroOne = 2*abs(kpsmodes1(:,2));
% non-dim
OneOne = OneOne/kappa;
ZeroOne = ZeroOne/kappa;
t = t/(pi^2/kappa);
subplot(1,3,2)
set(subplot(1,3,2), 'Position', [xstart+width+dif, ystart, width, height])
plot(t, OneOne, 'Color','blue'), hold on
plot(t, ZeroOne, 'Color','red');

xlim([2e4 4e4])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
text(2.05e4, 0.26, '(b) $\delta Ra = 10.7$', 'Color', 'black', 'FontSize',LabelFS)
xlabel({'$t$'},'Fontsize', LabelFS)



%% non-linear 2
kpsmodes1 = importdata('/Volumes/Samsung_T5/AR_2/64x64/Pr_0_01/Ra_5e3/Checks/kpsmodes1.txt');
Ra = 5e3;
Pr = 0.01;
kappa = sqrt((pi)^3/(Ra*Pr));
t = kpsmodes1(:,1);
OneOne = 2*sqrt(kpsmodes1(:,3).^2 + kpsmodes1(:,5).^2); % 2 as we have messed up the DNS
ZeroOne = 2*abs(kpsmodes1(:,2));
% non-dim
OneOne = OneOne/kappa;
ZeroOne = ZeroOne/kappa;
t = t/(pi^2/kappa);
subplot(1,3,3)
set(subplot(1,3,3), 'Position', [xstart+(width+dif)*2, ystart, width, height])
plot(t, OneOne, 'Color','blue'), hold on
plot(t, ZeroOne, 'Color','red');

xlim([100 2700])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel({'$t$'},'Fontsize', LabelFS)
text(180, 12.8, '(c) $\delta Ra = 2.22 \times 10^3$', 'Color', 'black', 'FontSize',LabelFS)
arrow([1100 7],[1030 7], 'length', 10)
arrow([1100 7],[1180 7], 'length', 10)
arrow([1500 7],[1180 7], 'length', 10)
arrow([1500 7],[1740 7], 'length', 10)
text((1180+1030)/2, 9, '(i)', 'Color', 'black', 'FontSize',numFS,'HorizontalAlignment', 'center')
text((1180+1740)/2, 9, '(ii)', 'Color', 'black', 'FontSize',numFS,'HorizontalAlignment', 'center')




%saveas(gcf,[figpath 'Solutions1.eps'], 'epsc')
