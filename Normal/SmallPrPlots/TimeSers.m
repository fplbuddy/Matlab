AR = 2; Pr = 0.03;
run SomeInputStuff.m
RaC = 1e2;
RaMax = 2e6;
%RaS_list = string(fieldnames(AllData.(ARS).(PrS)));
RaS_list = ["Ra_8_4e2" "Ra_2_1e3" "Ra_2_2e3" "Ra_8_3e3" "Ra_6e5" "Ra_1e6"];
figsave = '/Users/philipwinchester/Desktop/Figs/';
FS = 20;
for i=1:length(RaS_list)
    if (AllData.(ARS).(PrS).(RaS_list(i)).Ra > RaC && AllData.(ARS).(PrS).(RaS_list(i)).Ra < RaMax)
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS_list(i)).path) '/Checks/kpsmodes1.txt']);
        xlower = AllData.(ARS).(PrS).(RaS_list(i)).ICT;
        ZeroOne = kpsmodes1(:,2); ZeroOne = ZeroOne(xlower:end);
        OneOneR = kpsmodes1(:,3); OneOneR = OneOneR(xlower:end);
        OneOneI = kpsmodes1(:,5); OneOneI = OneOneI(xlower:end);
        OneOne = (OneOneI.^2+OneOneR.^2).^(0.5);
        t = kpsmodes1(:,1); t = t(xlower:end);
        phase = zeros(1,length(OneOne));
        kappa = AllData.(ARS).(PrS).(RaS_list(i)).kappa;
        ZeroOne = ZeroOne/kappa;
        OneOne = OneOne/kappa;
        t = t/(pi^2/kappa);
        for j=1:length(OneOne)
            phase(j) = wrapTo2Pi(angle(OneOneR(j) + 1i*OneOneI(j)));
        end
        figure('Renderer', 'painters', 'Position', [5 5 540 200])
        plot(t,abs(OneOne), 'LineWidth', 1), hold on
        %plot(t,abs(ZeroOne), 'LineWidth', 1)
        %plot(t,phase, 'LineWidth', 2)
        title(['$' AllData.(ARS).(PrS).(RaS_list(i)).title '$'],'FontSize',FS)
        xlabel('$t/((d\pi)^2/\kappa)$', 'FontSize',FS)
        xlim([min(t), max(t)])
        %xlim([340, 345])
        ax = gca;
        ax.XAxis.FontSize = FS;
        ax.YAxis.FontSize = FS;
        saveas(gcf,[figsave convertStringsToChars(RaS_list(i)) 'TimeSer.eps'], 'epsc')
    end
end
