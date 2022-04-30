figure('Renderer', 'painters', 'Position', [5 5 700 300])
ARS = 'AR_2';
PrS = 'Pr_30';
run SetUp.m
RaC = 3.5e4; RaMax = 5e4;
SDList = []; RaList = [];
Ra_list = string(fieldnames(AllData.(ARS).(PrS)));
for i=1:length(Ra_list)
    if (AllData.(ARS).(PrS).(Ra_list(i)).Ra <= RaMax && AllData.(ARS).(PrS).(Ra_list(i)).Ra > RaC)
        %urms = AllData.(ARS).(PrS).(Ra_list(i)).calcs.urms
        kappa = AllData.(ARS).(PrS).(Ra_list(i)).kappa;
        Ra = AllData.(ARS).(PrS).(Ra_list(i)).Ra;
        RaList = [Ra RaList];
        SDList = [AllData.(ARS).(PrS).(Ra_list(i)).calcs.sd*2/(kappa) SDList];
    end
end
sp = subplot(2,2,[1,3]);
sp.Position(2) = sp.Position(2) + 0.055;
sp.Position(4) = sp.Position(4) - 0.055;
I = find(RaList >= 4.78e4);
J = find(RaList == 4.78e4);
JJ = find(RaList == 4.5e4);
plot(RaList,SDList.^2,'b*'), hold on
%plot(RaList(J),SDList(J).^2,'b*')
%xlabel('$Ra$', 'FontSize',14)
%ylabel('$Var(\hat \psi_{0,1})$', 'FontSize',14)
%title(['$Pr =' num2str(Pr) '$'], 'FontSize',15)
% Fit data
RaList = RaList(I);
SDList = SDList(I);
[alpha, A, xFitted, yFitted, ~] = FitsLinear(RaList,SDList.^2);
plot(xFitted, yFitted, 'black--' )
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
ylabel('Var$(\widehat \psi_{0,1})/\kappa^2$', 'Fontsize', LabelFS, 'FontWeight', 'bold')
xlabel({'Ra'},'Fontsize', LabelFS)
annotation('arrow',[0.25 0.44],[0.78 0.70])
text(4.05e4,1.8,'Var$(\widehat \psi_{0,1}) \propto$ Ra - Ra$_c$', 'FontSize', LabelFS)
text(4.05e4,1.2,'Ra$_c \approx 4.77 \times 10^4$', 'FontSize', LabelFS)
text(4.05e4,0.2,'(a)', 'FontSize', LabelFS)
%gtext(['$Var(\hat \psi_{0,1}) =' num2str(alpha,3) 'Ra - Ra_C$'],'FontSize',14,'color', 'black')
%clearvars -except AllData Data

%%
stretch = 0.001;
RaS = 'Ra_4_77e4';
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
t1 = kpsmodes1(:,1);
Signal1 = kpsmodes1(:,2);
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
xlower = AllData.(ARS).(PrS).(RaS).ICT;
% Calculating urms and kappa
urms = AllData.(ARS).(PrS).(RaS).urms;
kappa = AllData.(ARS).(PrS).(RaS).kappa;

% non-dim stuff
Signal1 = Signal1*2/kappa;
t1 = t1/(pi/urms);
sp = subplot(2,2,2);
plot(t1,Signal1,'b-')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([t1(end)-50 t1(end)])
xticks([t1(end)-40 t1(end)-30 t1(end)-20 t1(end)-10])
xticklabels({'' '' ''});
ylabel('$\widehat \psi_{0,1}/\kappa$', 'Fontsize', LabelFS, 'FontWeight', 'bold')
% sp.Position(2) = sp.Position(2) - stretch;
% sp.Position(4) = sp.Position(4) + stretch;
tit = title('Ra $=4.77 \times 10^4$', 'FontSize', TitleFS);
tit.Position(1) = tit.Position(1) + 8;
%
%
RaS = 'Ra_4_769e4';
kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kpsmodes1.txt']);
t2 = kpsmodes1(:,1);
Signal2 = kpsmodes1(:,2);
kenergy = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS).path) '/Checks/kenergy.txt']);
xlower = AllData.(ARS).(PrS).(RaS).ICT;
% Calculating urms and kappa
urms = AllData.(ARS).(PrS).(RaS).urms;
kappa = AllData.(ARS).(PrS).(RaS).kappa;

% non-dim stuff
Signal2 = Signal2*2/kappa;
t2 = t2/(pi/urms);
sp = subplot(2,2,4);
plot(t2,Signal2, 'b-')
ax = gca;
ax.XAxis.FontSize = numFS;
ax.YAxis.FontSize = numFS;
xlim([400 450])
xticklabels({'100' '110' '120' '130' '140' '150'});
ylab = ylabel('$\widehat \psi_{0,1}/\kappa$', 'Fontsize', LabelFS, 'FontWeight', 'bold');
ylab.Position(1) = ylab.Position(1) - 3;
xlabel({'$t/(\pi d/u_{rms})$'},'Fontsize', LabelFS)
% sp.Position(4) = sp.Position(4) + stretch;
tit = title('Ra $=4.769 \times 10^4$', 'FontSize', TitleFS);
tit.Position(1) = tit.Position(1) + 8;


