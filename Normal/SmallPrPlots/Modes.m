AR = 2; Pr = 0.01;
run SomeInputStuff.m
RaC = 1e3;
%RaS_list = string(fieldnames(AllData.(ARS).(PrS)));
RaS_list = ["Ra_2e3" "Ra_3e3" "Ra_4e3" "Ra_5e3" "Ra_6e3" "Ra_1e4"];
figsave = '/Users/philipwinchester/Desktop/Figs/';
FS = 20;
figure('Renderer', 'painters', 'Position', [5 5 540 250])
for i=1:length(RaS_list)
    if (AllData.(ARS).(PrS).(RaS_list(i)).Ra > RaC)
        Ra = RaStoRa((RaS_list(i)));
        kpsmodes1 = importdata([convertStringsToChars(AllData.(ARS).(PrS).(RaS_list(i)).path) '/Checks/kpsmodes1.txt']);
        xlower = AllData.(ARS).(PrS).(RaS_list(i)).ICT;
        ZeroOne = kpsmodes1(:,2); ZeroOne = ZeroOne(xlower:end);
        OneOneR = kpsmodes1(:,3); OneOneR = OneOneR(xlower:end);
        OneOneI = kpsmodes1(:,5); OneOneI = OneOneI(xlower:end);
        OneOne = (OneOneI.^2+OneOneR.^2).^(0.5);
        kappa = AllData.(ARS).(PrS).(RaS_list(i)).kappa;
        ZeroOne = ZeroOne/kappa;
        OneOne = OneOne/kappa;
        plot(abs(OneOne), abs(ZeroOne),'LineWidth', 2, 'DisplayName', num2str(Ra)), hold on
        title('Pr = $10^{-2}$','FontSize',FS)
        xlabel('$| \widehat \psi_{1,1} |/\kappa$', 'FontSize',FS)
        ylabel('$| \widehat \psi_{0,1} |/\kappa$', 'FontSize',FS)
        
        ax = gca;
        ax.XAxis.FontSize = FS;
        ax.YAxis.FontSize = FS;
    end
end
lgnd = legend('Location', 'Bestoutside', 'FontSize', FS); title(lgnd,'$Ra$', 'FontSize', FS)
saveas(gcf,[figsave 'Modes.eps'], 'epsc')