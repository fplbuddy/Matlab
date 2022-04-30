run SetUp.m
load('/Volumes/Samsung_T5/OldData//masternew.mat')
AR = 'AR_2';
PrS = 'Pr_30';
type = 'OneOne32';

%% GetData
RaC = round(8*pi^4,4);
Ra_list = [1e-4 2e-4 3e-4 6e-4 1e-3 2e-3 3e-3 6e-3 1e-2 2e-2 3e-2 6e-2 1e-1 2e-1 3e-1 6e-1 1 2 3 6 10 20 30 60 100 200 300 600] + RaC;
OneOne = zeros(length(Ra_list),1);
ThreeOne = zeros(length(Ra_list),1);
OneThree = zeros(length(Ra_list),1);
TwoTwo = zeros(length(Ra_list),1);
for i =1:length(Ra_list)
   Ra = Ra_list(i);
   RaS = RatoRaS(Ra);
   PsiE = Data.(AR).(type).(PrS).(RaS).PsiE;
   OneOne(i) = abs(PsiE(1));
   ThreeOne(i) = abs(PsiE(2));
   OneThree(i) = abs(PsiE(18));
   TwoTwo(i) = abs(PsiE(10));
end
% type = 'OneOne64';
% Ra_list = [1000 2000 3000 6000 10000] + RaC;
% for i =1:length(Ra_list)
%    Ra = Ra_list(i);
%    RaS = RatoRaS(Ra);
%    PsiE = Data.(AR).(type).(PrS).(RaS).PsiE;
%    OneOne = [OneOne; abs(PsiE(1))];
%    ThreeOne = [ThreeOne; abs(PsiE(2))];
%    OneThree = [OneThree; abs(PsiE(34))];
%    TwoTwo = [TwoTwo; abs(PsiE(18))];
% end
% Ra_list = [1e-4 2e-4 3e-4 6e-4 1e-3 2e-3 3e-3 6e-3 1e-2 2e-2 3e-2 6e-2 1e-1 2e-1 3e-1 6e-1 1 2 3 6 10 20 30 60 100 200 300 600 1000 2000 3000 6000 10000] + RaC;
%% OneOne with Ra
figure('Renderer', 'painters', 'Position', [5 5 700 350])
subplot(2,2,1)
loglog(Ra_list - RaC, OneOne, '*'), hold on
[alpha, ~, xFitted, yFitted, ~] = FitsPowerLaw(Ra_list - RaC,OneOne);
plot(xFitted, yFitted, 'black--'), hold off
xlim([9e-5 1000])
ylim([6e-4 2])
xticks([1e-4 1e-2 1 100])
yticks([1e-3 1])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('Ra-Ra$_c$', 'FontSize', LabelFS)
ylabel('$|\widehat \psi_{1,1}|/\kappa$', 'FontSize', LabelFS)
title(['$|\widehat \psi_{1,1}| \propto ($Ra-Ra$_c)^{' num2str(alpha,3) '}$'], 'FontSize', TitleFS)
% ThreeOne with OneOne
subplot(2,2,3)
loglog(OneOne, ThreeOne, '*'), hold on
[alpha, ~, xFitted, yFitted, ~] = FitsPowerLaw(OneOne,ThreeOne);
plot(xFitted, yFitted, 'black--'), hold off
xlim([6e-4 2])
ylim([2e-20 0.004])
xticks([1e-3 1])
yticks([1e-19 1e-11 1e-3])
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlabel('$|\widehat \psi_{1,1}|/\kappa$', 'FontSize', LabelFS)
ylabel('$|\widehat \psi_{3,1}|/\kappa$', 'FontSize', LabelFS)
title(['$|\widehat \psi_{3,1}| \propto |\widehat \psi_{1,1}|^{' num2str(alpha,3) '}$'], 'FontSize', TitleFS)
annotation('arrow',[0.22 0.32],[0.21 0.28])
text(2e-2,1e-17,'Ra', 'FontSize', LabelFS)


% Making the fields
N = 32;
Ra = 100 + RaC;
RaS = RatoRaS(Ra);
[PsiPlot, ThetaPlot] =  PlotEvenFunc(Data.(AR).(type).(PrS).(RaS).PsiE, Data.(AR).(type).(PrS).(RaS).ThetaE, 32, 1);
subplot(2,2,2)
pcolor(PsiPlot);
shading flat
colormap('jet')
c = colorbar;
c.FontSize = numFS;
xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
ylabel('$y/(\pi d)$', 'FontSize', LabelFS)
xticks([1 2*N])
xticklabels({'$0$' '$\Gamma$'})
yticks([1 2*N])
yticklabels({'$0$' '$1$'})
title('$\psi/\kappa$', 'FontSize', TitleFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;

subplot(2,2,4)
pcolor(ThetaPlot);
shading flat
colormap('jet')
c = colorbar;
c.FontSize = numFS;
xlabel('$x/(\pi d)$', 'FontSize', LabelFS)
ylabel('$y/(\pi d)$', 'FontSize', LabelFS)
xticks([1 2*N])
xticklabels({'$0$' '$\Gamma$'})
yticks([1 2*N])
yticklabels({'$0$' '$1$'})
title('$\theta/\Delta T$', 'FontSize', TitleFS)
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;

